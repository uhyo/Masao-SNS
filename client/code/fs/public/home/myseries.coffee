
exports._init=(option,suburl,loader)->
	app=require '/app'
	util=require '/util'
	
	query=
		userid:app.getId()
	sort={}
	
	ss.rpc "series.serieslist", query,sort, (docs)->
		if docs.error?
			#エラー
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:docs.error}
			return
		node=loader null,{myseries:docs}
		
		newseries=$(".newseriesform",node)
		
		newseries.submit (je)->
			je.preventDefault()
			ss.rpc "series.newseries",util.formQuery(je.target),(result)->
				if result.error?
					app.error loader.parent,{message: result.error}
				else
					app.startURL loader.parent,"/manager/series/#{result._id}"
		
	return end:->

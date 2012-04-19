
exports._init=(option,suburl,loader)->
	app=require '/app'
	
	query=
		userid:app.getId()
	sort={}
	
	ss.rpc "resource.resourcelist", query,sort, (docs)->
		if docs.error?
			#エラー
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:docs.error}
			return
		node=loader null,{resources:docs}
		
	return end:->

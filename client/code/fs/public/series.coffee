# option:{}
exports._init=(option,suburl,loader)->

	seriesid=suburl.slice 1	#/を取り除く
	ss.rpc "series.getSeries",{_id:seriesid},(doc)->
		app=require '/app'
		if doc.error?
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:doc.error}
			return
		node=loader()
		
		seriesinfo=$(".seriesinfo",node)
		seriesinfo.append $ JT["tmp-seriesbox"] {series:doc}
		serieslist=$(".serieslist",node)
		app.startURL serieslist,"/masaolist/series/#{seriesid}"
		
			
		
	
	return end:->
	

# option:{}
exports._init=(option,suburl,loader)->

	masaoid=suburl.slice 1	#/を取り除く
	# 正男を問い合わせる
	masaoloader=require '/masaoloader'
	masaoloader.loadMasao masaoid,(doc)->
		app=require '/app'
		if doc.error?
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:doc.error}
			return
		#正男がある
		console.log doc
		masao=doc.masao
		node=loader null,doc
		wrapper=$(node).find "div.masaowrapper"

		wrapper.append masaoloader.getMasaoObject doc
		
	
	return end:->
	

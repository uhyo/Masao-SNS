# option:{}
exports._init=(option,suburl,loader)->

	masaoid=suburl.slice 1	#/を取り除く
	# 正男を問い合わせる
	require('/masaoloader').loadMasao masaoid,(doc)->
		app=require '/app'
		if doc.error?
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:doc.error}
			return
		#正男がある
		masao=doc.masao
		node=loader null,doc
		
		
	
	return end:->

#param要素を作る
param=(name,value)->
	p=document.createElement "param"
	p.name=name
	p.value=value
	p
	

# option:{}
exports._init=(option,suburl,loader)->

	masaoid=suburl.slice 1	#/を取り除く
	# 正男を問い合わせる
	query={}
	if /^\d+$/.test masaoid
		query.number=parseInt masaoid
	else if masaoid
		query._id=masaoid
	else
		# 何もない
		node=loader()
		return
		
	ss.rpc "masao.getMasao",query,(doc)->
		app=require '/app'
		if doc.error?
			app.startProcess loader.parent,require('/special/error'),null,null,{title:"エラー",message:doc.error}
			return
		#正男がある
		node=loader null,doc
		object=$(node).find("object.masaoobject")
		#paramをセットする
		#まずcode
		masao=doc.masao
		object.append param "code", "MasaoConstruction.class" #typeによる振り分けは?
		#ほか
		for key,value of masao.params
			object.append param key,value
		
	
	return end:->

#param要素を作る
param=(name,value)->
	p=document.createElement "param"
	p.name=name
	p.value=value
	p
	

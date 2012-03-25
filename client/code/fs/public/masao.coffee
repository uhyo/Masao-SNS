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
		console.log doc
		masao=doc.masao
		node=loader null,doc
		wrapper=$(node).find "div.masaowrapper"
		#オブジェクトを作る
		object=$(document.createElement "object")
		object.attr "type","application/x-java-applet"
		object.attr "width","512"
		object.attr "height","320"
		
		#ファイル名はhard coding
		for x in ["title","ending","gameover","pattern"]
			unless doc.resources[x]?
				masao.params["filename_#{x}"]="/masaofiles/#{x}.gif"
		
		#paramをセットする
		#まずcode
		object.append param "code", "MasaoConstruction" #typeによる振り分けは?
		#archive
		object.append param "archive", "/masaofiles/"+switch masao.type
			when "normal","classic" then "mc_c.zip"
			when "fx" then "mc_c.jar"
		#ほか
		for key,value of masao.params
			object.append param key,value
			
		wrapper.append object
		
	
	return end:->

#param要素を作る
param=(name,value)->
	p=document.createElement "param"
	p.name=name
	p.value=value
	p
	

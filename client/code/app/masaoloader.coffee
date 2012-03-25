#Masao loading module
exports.loadMasao=(masaoid,cb)->
	# masaoidが表す正男を読み込む
	query={}
	if /^\d+$/.test masaoid
		query.number=parseInt masaoid
	else if masaoid
		query._id=masaoid
	else
		cb {error:"正男IDが不正です"}
		return
	ss.rpc "masao.getMasao",query,cb
	
# 正男のobject要素を作る
#doc: DBに入っているやつ
exports.getMasaoObject=(doc)->
	object=$(document.createElement "object")
	object.attr "type","application/x-java-applet"
	object.attr "width","512"
	object.attr "height","320"
	
	masao=doc.masao
	
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
	object.get 0
#param要素を作る
param=(name,value)->
	p=document.createElement "param"
	p.name=name
	p.value=value
	p

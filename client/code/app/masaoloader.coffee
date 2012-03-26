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
	
	# code,archive,basedir（ファイルの親）
	code="MasaoConstruction"
	archive=null
	basedir=null
	switch masao.type
		when "normal","classic"
			archive="mc_c.zip"
			basedir=masao.version	#"3.1"とか
		when "fx"
			archive="mc_c.jar"
			basedir="fx#{masao.version}"	#"fx16"とか
	
	#ファイル名はhard coding
	for x in ["title","ending","gameover","pattern"]
		unless doc.resources[x]?
			masao.params["filename_#{x}"]="/masaofiles/#{basedir}/#{x}.gif"
	
	#paramをセットする
	#まずcode
	object.append param "code", code #typeによる振り分けは?
	#archive
	object.append param "archive", "/masaofiles/#{basedir}/#{archive}"
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

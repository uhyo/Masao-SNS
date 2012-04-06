#Masao loading module
exports.loadMasao=(masaoid,cb)->
	# masaoidが表す正男を読み込む
	query={}
	if /^\d+$/.test masaoid
		query._id=parseInt masaoid
	else
		cb {error:"正男IDが不正です"}
		return
	ss.rpc "masao.getMasao",query,cb
exports.viewMasao=(masaoid,cb)->
	# masaoidが表す正男を閲覧
	query={}
	if /^\d+$/.test masaoid
		query._id=parseInt masaoid
	else
		cb {error:"正男IDが不正です"}
		return
	ss.rpc "masao.viewMasao",query,cb
	
# 正男のobject要素を作る
#doc: DBに入っているやつ
exports.getMasaoObject=(doc)->
	object=$(document.createElement "object")
	object.attr "type","application/x-java-applet"
	object.attr "width","512"
	object.attr "height","320"
	
	masao=doc.masao
	
	# code,archive,basedir（ファイルの親）
	code=masao.code ? "MasaoConstruction"
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
	#se
	se_default=
		#filename_se_start: item.au"
		start:"item"
		gameover:"gameover"
		clear:"clear"
		coin:"coin"
		get:"get"
		item:"item"
		jump:"jump"
		sjump:"sjump"
		kiki:"kiki"
		fumu:"fumu"
		tobasu:"tobasu"
		fireball:"shot"
		jet:"mgan"
		miss:"dosun"
		block:"bakuhatu"
		mizu:"mizu"
		dengeki:"mgan"
		happa:"happa"
		hinoko:"mgan"
		mizudeppo:"happa"
		bomb:"shot"
		dosun:"dosun"
		gronder:"mgan"
		kaiole:"happa"
		senkuuza:"shot"
		dokan:"get"
		chizugamen:"get"
	for name,value of se_default
		unless doc.resources["se_#{name}"]?
			masao.params["filename_se_#{name}"]="/masaofiles/#{basedir}/#{value}.au"
		
	
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

# アップロードフォーム
#option.submit: 送信時に呼ばれる関数（引数：フォーム）
#option.requirefile: ファイルが必要かどうか
#option.user_id: 検索のデフォルトのユーザーID
exports._init=(option={},suburl,loader)->
	form=loader "special-masao-uploadform"
	testplay=$(".testplayarea",form)
	message=$(".messagearea",form)
	
	resourceedit=$(".resourceedit",form)
	
	app=require '/app'
	masaoloader=require '/masaoloader'
	util=require '/util'
	
	masaodoc={}	# 正男のDBオブジェクト
	
	resourcesObject={}	# 正男のリソース
	
	# プレビュー
	$("input[type=\"file\"]",form).prop("required",option.requirefile ? false).change (je)->

		# ファイルを取得
		file=form.elements["file"].files[0]
		return unless file?
		
		# 中身を取得しよう！
		reader=new FileReader()
		reader.onload=(e)->
			# XHR
			parser=new DOMParser
			doc= parser.parseFromString reader.result,"text/html"
			unless doc?
				# 正男がないよ！
				app.error message,{message:"正男を読み込めませんでした。"}
				return
				
			# ドキュメントから正男を探す
			applets=$ "applet",doc
			[code,archive]=[null,null]
			if applets.length>0
				# アプレットを発見
				code=applets.attr "code"
				archive=applets.attr "archive"
				masaodoc=makeDocObject applets.get 0
			else
				# objectを探す
				objects=$ "object",doc
				if objects.length>0
					code=objects.find("param[name=\"code\"]").attr "value"
					archive=objects.find("param[name=\"archive\"]").attr "value"
					masaodoc=makeDocObject objects.get 0
			
			# 探し終わった
			unless code?
				# 見つからない
				app.error message,{message:"正男が見つかりませんでした。"}

				je.target.setCustomValidity "正男ファイルが設定されていません"
				form.elements["testplay"].disabled=true
				masaodoc={}
				return
			je.target.setCustomValidity ""
			form.elements["testplay"].disabled=false
			form.elements["title"].value=doc.title
			
			#archiveに基づいて正男判定
			if /mc_c\.jar$/.test archive
				# FX
				form.elements["type"].value="fx"
				chkVersion form
				form.elements["version"].value="16"	#hard coding
			else
				form.elements["type"].value="normal"
				chkVersion form
				form.elements["version"].value="3.1"
			form.elements["code"].value=code

			masaodoc.masao.type=form.elements["type"].value
			masaodoc.masao.version=form.elements["version"].value
			masaodoc.masao.code=code
			
		reader.readAsText file

	$(form).submit (je)->
		je.preventDefault()
		masaodoc[x]=form.elements[x].value for x in ["title","author","description"]
		if masaodoc.masao?
			masaodoc.masao[x]=form.elements[x].value for x in ["type","version","code"]
			
		masaodoc.resources=resourceeditcont.cont.getResources()

		option.submit? je.target
		
	# リソース選択
	###
	$(form.elements["resourcefindbutton"]).click (je)->
		opt=
			user_id:form.elements["resourceuserid"].value
			usage:form.elements["resourceusage"].value
			select:(resource)->
				# 選ばれたら呼ばれる
				usage=form.elements["resourceusage"].value || resource.usage
				unless usage
					return
				resources.find(".resourcebox").filter((idx)->@dataset.usage==usage).remove()
				resourcesObject[usage]=resource._id
				resources.append getResourceBox resource,usage
				
				
		unless form.elements["resourceusageeq"].checked
			delete opt.usage
		
		app.startURL selectarea,"/resourcelist",opt
	if option.user_id
		form.elements["resourceuserid"].value=option.user_id
	###
	resourceeditcont = app.startProcess resourceedit,require('/special/resource/chooseresource'),null,"/",{
		user_id: option.user_id
		title:"使用リソース"
	}
		
	chkVersion form
	# 変更
	$("select[name=\"type\"]",form).change chkVersion.bind null,form
	# テストプレイ
	$(form.elements["testplay"]).click (je)->
		# テストプレイ
		return unless masaodoc?

		masaodoc.masao.type=form.elements["type"].value
		masaodoc.masao.version=form.elements["version"].value
		masaodoc.masao.code=form.elements["code"].value
		testplay.empty().append masaoloader.getMasaoObject masaodoc
		
		
	return {
		end:->
		setForm:(doc)->
			masaodoc=doc
			resourcesObject=doc.resources ? {}
			# masaoに入っていたdocからフォーム入力
			for x in ["title","description","author"]
				form.elements[x].value=doc[x]
				
			form.elements["type"].value=doc.masao.type
			chkVersion form
			for x in ["version","code"]
				form.elements[x].value=doc.masao[x]
			
			resourceeditcont.cont.setResources resourcesObject
			
			
			
		requiresFile:(flg)->
			form.elements["file"].required=flg
		# base64 binaryをcbに渡す
		getMasao:(cb)->
			cb masaodoc


	}
# フォームのアレに応じてヴァージョン変える
chkVersion=(form)->
	type=form.elements["type"].value
	sl=form.elements["version"]	# select要素
	choices=switch type
		when "normal"
			["2.8","3.0","3.1"]
		when "classic"
			["3.1"]
		when "fx"
			["16"]
	$(sl).empty()
	choices.forEach (x)->
		sl.add $("<option value='#{x}'>#{x}</option>").get 0
		
# applet,objectからdocを作る
makeDocObject=(applet)->
	masao=
		tags:
			script:""
			header:""
			footer:""
		type:"normal"
		version:"3.1"
		code:"MasaoConstruction"
	
	params={}
	$(applet).find("param").each ->
		params[@name]=@value
	masao.params=params
	doc=
		masao:masao
		author:null
		title:null
		description:null
		user:
			_id:null
			name:null
		resources:{}
	doc
	
# resourcebox @return jQuery
getResourceBox=(resource,usage)->
	result=$ JT["tmp-resourcebox"] {resource:resource}
	result.prop("dataset").usage=usage
	result

# option:{}
exports._init=(option,suburl,loader)->

	app=require '/app'
	masaoloader=require '/masaoloader'
	
	masaodoc=null	# 正男のDBオブジェクト
	
	app.assertLogin loader.parent,"正男をアップロードするにはログインして下さい。",->
		node=loader()
		
		$("#uploadform input[type=\"file\"]").change (je)->
			form=je.target.form
			
			$("#messagearea").empty()
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
					app.error $("#messagearea"),{message:"正男を読み込めませんでした。"}
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
					app.error $("#messagearea"),{message:"正男が見つかりませんでした。"}
					je.target.setCustomValidity "正男ファイルが設定されていません"
					form.elements["testplay"].disabled=true
					masaodoc=null
					return
				je.target.setCustomValidity ""
				form.elements["testplay"].disabled=false
				
				#archiveに基づいて正男判定(code未使用...)
				if /mc_c\.jar$/.test archive
					# FX
					form.elements["type"].value="fx"
					chkVersion form
					form.elements["version"].value="16"	#hard coding
				else
					form.elements["type"].value="normal"
					chkVersion form
					form.elements["version"].value="3.1"
				masaodoc.masao.type=form.elements["type"].value
				masaodoc.masao.version=form.elements["version"].value
				
				
				
					
				
			reader.readAsText file
		
		form=$("#uploadform").get 0
		chkVersion form
		# 変更
		$("#uploadform select[name=\"type\"]").change chkVersion.bind null,form
		# テストプレイ
		$(form.elements["testplay"]).click (je)->
			# テストプレイ
			masaodoc.masao.type=form.elements["type"].value
			masaodoc.masao.version=form.elements["version"].value
			$("#testplayarea").empty().append masaoloader.getMasaoObject masaodoc
	return end:->

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
	
	params={}
	$(applet).find("param").each ->
		params[@name]=@value
	masao.params=params
	doc=
		masao:masao
		number:null	#名前はまだない
		author:null
		title:null
		description:null
		user:
			_id:null
			name:null
		resources:{}
	doc

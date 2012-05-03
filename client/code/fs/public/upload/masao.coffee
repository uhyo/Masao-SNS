# option:{}
exports._init=(option,suburl,loader)->

	app=require '/app'
	masaoloader=require '/masaoloader'
	
	masaodoc=null	# 正男のDBオブジェクト
	
	app.assertLogin loader.parent,"正男をアップロードするにはログインして下さい。",->
		node=loader()
		
		controller=app.startProcess $("#uploadarea"),require('/special/masao/uploadform'),null,"",{
			requirefile:true
			user_id:app.getId()
			submit:(form)->
				controller.cont.getMasao (masaodoc)->
					ss.rpc "masao.upload",masaodoc,(result)->
						if result.error?
							app.error $(".messagearea",node),message:result.error
							return
						if result.success
							# 正男ページに移動
							app.startURL loader.parent,"/masao/#{result.number}"
		}
			
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

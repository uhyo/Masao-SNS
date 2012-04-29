# option:{}
exports._init=(option,suburl,loader)->
	app=require '/app'

	masaoid=suburl.slice 1	#/を取り除く
	# 正男を問い合わせる
	app.assertLogin loader.parent,"正男管理を行うにはログインして下さい。",->
		require('/masaoloader').loadMasao masaoid,(doc)->
			app=require '/app'
			if doc.error?
				app.error loader.parent,{title:"エラー",message:doc.error}
				return
			#正男がある
			masao=doc.masao
			node=loader null,doc
			
			manager=$(".managerarea",node)
			message=$(".messagearea",node)
			
			controller=app.startProcess manager,require('/special/masao/uploadform'),null,null,{
				requireFile:false
				submit:(form)->
					controller.cont.getMasao (masaodoc)->
						masaodoc._id=masaoid
						ss.rpc "masao.update",masaodoc,(obj)->
							console.log obj,message
							if obj?.error?
								#エラー
								app.error message,{title:"エラー",message:obj.error}
								return
							#成功
							app.message message,{title:"正男管理",message:"情報を変更しました。",link:{text:"正男ページを開く",href:"/masao/#{masaoid}"}}
			}
			controller.cont.setForm doc
			
	
	return end:->
	

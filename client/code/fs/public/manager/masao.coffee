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
	
			$("#masaomanagerform").submit (je)->
				je.preventDefault()
				query=require('/util').formQuery je.target
		
				ss.rpc "masao.manage",query,(obj)->
					if obj?.error?
						#エラー
						app.error $("#messagearea"),{title:"エラー",message:obj.error}
						return
					#成功
					app.message $("#messagearea"),{title:"正男管理",message:"情報を変更しました。"}
			
	
	return end:->

#param要素を作る
param=(name,value)->
	p=document.createElement "param"
	p.name=name
	p.value=value
	p
	

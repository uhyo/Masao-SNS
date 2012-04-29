# option:{}
exports._init=(option,suburl,loader)->

	app=require '/app'
	util=require '/util'
	

	app.assertLogin loader.parent,"ファイルをアップロードするにはログインして下さい。",->
		node=loader()
		messagearea=$(".messagearea",node)
		
		controller=app.startProcess $(".formarea",node).get(0),require('/special/resource/uploadform'),null,null, submit:(form)->

			controller.cont.getFile (base64data)->
				
				query=
					type:form.elements["type"].value
					name:form.elements["name"].value
					size:form.elements["size"].value
					usage:form.elements["usage"].value
					comment:form.elements["comment"].value
					
					data:base64data
					
				ss.rpc "resource.upload",query,(result)->
					if result.error?
						app.error $("#messagearea"),{message:result.error}
					else
						app.message loader.parent,{message:"アップロードしました。",link:{href:"/manager/resource/#{result._id}",text:"詳細を見る"}}
			app.message messagearea,{message:"アップロードしています..."}
		
				

	return end:->

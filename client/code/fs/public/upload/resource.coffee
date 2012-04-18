# option:{}
exports._init=(option,suburl,loader)->

	app=require '/app'
	util=require '/util'
	

	app.assertLogin loader.parent,"ファイルをアップロードするにはログインして下さい。",->
		node=loader()
		messagearea=$(".messagearea",node)
		
		form=app.startProcess $(".formarea",node).get(0),require('/special/resource/uploadform'),null,null, submit:(form)->

			file=form.elements["file"].files[0]
			return unless file?
			
			reader=new FileReader()
			reader.onload=(e)->
				#reader.result:ArrayBuffer
				arr=new Uint8Array reader.result
				#arrにデータ
				string=Array.prototype.map.call(arr,(x)->String.fromCharCode x).join ""
				base64data=btoa string
				
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
			reader.readAsArrayBuffer file
		
				

	return end:->

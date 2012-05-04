# option:{}
exports._init=(option,suburl,loader)->
	app=require '/app'

	seriesid=suburl.slice 1	#/を取り除く
	app.assertLogin loader.parent,"シリーズ管理を行うにはログインして下さい。",->
		ss.rpc "series.getSeries",{_id:seriesid},(series)->
			unless series?
				app.error loader.parent,{message:"そのシリーズは存在しません"}
				return
			
			node=loader null,series
			
			message=$(".messagearea",node)
			resourceedit=$(".resourceedit",node)
			
			resourceeditcont=app.startProcess resourceedit,require('/special/resource/chooseresource'),null,"/",{
				title:"初期リソース"
				user_id: app.getId()
				resourcesObject: series.resources
			}
			
			form=$("form.seriesmanageform",node).get 0
			$(form).submit (je)->
				je.preventDefault()
				query=
					_id:seriesid
					name:form.elements["name"].value
					resources:resourceeditcont.cont.getResources()
				ss.rpc "series.manage",query,(result)->
					if result.error?
						app.error message,{message:result.error}
						return
					app.message message,{message:"情報を更新しました。"}
		
	return end:->
	

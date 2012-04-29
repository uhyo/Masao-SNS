# option:{}
exports._init=(option,suburl,loader)->
	app=require '/app'
	util=require '/util'

	resource_id=suburl.slice 1	#/を取り除く
	# リソースを問い合わせる
	query=
		_id:resource_id
		data:true
		
	ss.rpc "resource.getResource",query,(result)->
		if result.error?
			app.error loader.parent,{message:result.error}
			return
		console.log result
		node=loader null,result
		# プレビュー
		img=util.previewImage "data:#{result.type};base64,#{result.data}"
		a=document.createElement "a"
		a.href="/resource/#{resource_id}"
		a.target="_blank"
		a.appendChild img
		$(".preview",node).append a
		
		# フォーム
		controller=app.startProcess $(".formarea",node),require('/special/resource/uploadform'),null,null, submit:(form)->
			query=
				type:form.elements["type"].value
				name:form.elements["name"].value
				size:form.elements["size"].value
				usage:form.elements["usage"].value
				comment:form.elements["comment"].value
			
			query._id=resource_id	# 更新
			
			controller.cont.getFile (base64data)->
				if base64data?
					query.data=base64data
				ss.rpc "resource.update",query,(result)->
					if result.error?
						app.error loader.parent,{message:result.error}
						return
					app.startURL loader.parent,"/manager/resource/#{resource_id}"
					
		
		if app.getId()!=result.user.id
			# 管理者ではない
			$(".formarea",node).prop "hidden",true
			$(".dataarea",node).prop "hidden",false
		
		
		controller.cont.setForm result
		controller.cont.requiresFile false	# ファイルが無くても可
	
	return end:->

	

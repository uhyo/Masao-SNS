
exports._init=(option,suburl,loader)->
	node=loader()
	
	SS.server.users.myData (user)->
		if user?
			form=$("#profileform").get(0)
			form.elements["name"].value=user.name
	
	$("#profileform").submit (je)->
		je.preventDefault()
		form=je.target
		# サーバーと通信
		query=SS.client.util.formQuery form
		SS.server.users.changeMyProfile query,(error)->
			if error?
				form.elements["error"].value=error
			else
				# 成功した
				SS.client.app.startURL loader.parent,"/home/info"
	.on "input", (je)->
		form=je.target.form
		pw=form.elements["newpassword"]
		pw2=form.elements["newpassword2"]
		if pw.value && pw.value!=pw2.value
			pw2.setCustomValidity "新しいパスワードが一致しません。"
		else
			pw2.setCustomValidity ""
		$("#newpassagain").get(0).hidden = pw.value==""
		
	return end:->

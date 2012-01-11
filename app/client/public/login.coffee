
#新しくセッションが開始されたときに呼ばれる
#セッションを終了するためのメソッドを返す
#optionは必要なとき loader:templateを自動でロードして追加までしてくれるはず
#suburl: 処理されなかったURLの情報文字列
# { end: -> }
exports._init=(option,suburl,loader)->
	node=loader()
	$("#loginform").submit (je)->
		je.preventDefault()
		login je.target	#ログインする
	$("#newaccountform").submit (je)->
		je.preventDefault()
		newuser je.target	# 新規登録
	$(node).on "click","a",(je)->
		# #newaccountへ
		href=je.target.href
		return unless href
		url=$.url href
		if url.attr('path')==location.pathname && url.attr('fragment')=="newaccount"
			$("#newaccount").get(0).hidden=false
			je.preventDefault()
	if location.hash=="#newaccount"
		$("#newaccount").get(0).hidden=false
		
	return end:->

login=(form)->
	loginquery form.elements["id"].value, form.elements["password"].value,(err)->
		if err?
			form.elements["error"].value=err
# ログインのクエリを送る
loginquery=(id,pass,cb=->)->
	query=
		id:id
		password:pass
	SS.server.users.login query,(error)->
		if error?
			cb error
		else
			# ログインに成功
			SS.client.app.setId id
			cb null

newuser=(form)->
	query=
		id:form.elements["id"].value
		password:form.elements["password"].value
	SS.server.users.newuser query,(error)->
		if error?
			form.elements["error"].value=error
		else
			# 新規登録に成功したらログイン
			loginquery query.id,query.password

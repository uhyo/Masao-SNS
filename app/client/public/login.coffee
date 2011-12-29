
#新しくセッションが開始されたときに呼ばれる
#セッションを終了するためのメソッドを返す
#optionは必要なとき loader:templateを自動でロードして追加までしてくれるはず
#suburl: 処理されなかったURLの情報文字列
# { end: -> }
exports.init=(option,suburl,loader)->
	node=loader()
	$("#loginform").submit (je)->
		je.preventDefault()
		alert "ログイン（未完成）"
	$("#newaccountform").submit (je)->
		je.preventDefault()
		alert "新規登録（未完成）"
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

#新しくセッションが開始されたときに呼ばれる
#セッションを終了するためのメソッドを返す
#optionは必要なとき loader:templateを自動でロードして追加までしてくれるはず
#suburl: 処理されなかったURLの情報文字列
# { end: -> }
exports.init=(option,suburl,loader)->
	node=loader "special-top"
	if suburl!="/"
		# そんなページは知らない
		SS.client.app.startProcess node,SS.client.special["404"],null,suburl
		return
	# トップはログインフォーム表示
	SS.client.app.startURL  node,"/login"

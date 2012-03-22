#新しくセッションが開始されたときに呼ばれる
#セッションを終了するためのメソッドを返す
#optionは必要なとき loader:templateを自動でロードして追加までしてくれるはず
#suburl: 処理されなかったURLの情報文字列
# { end: -> }
exports._init=(option,suburl,loader)->
	node=loader "special-top"
	app=require '/app'
	if suburl!="/"
		# そんなページは知らない
		app.startProcess node,require('/public/login'),null,suburl
		return
	# トップはログインフォーム表示
	app.startURL  node,"/login"

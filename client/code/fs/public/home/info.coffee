
exports._init=(option,suburl,loader)->
	# サーバーから情報を取得
	SS.server.users.myData (user)->
		console.log user
		node=loader null,user
		
	return end:->

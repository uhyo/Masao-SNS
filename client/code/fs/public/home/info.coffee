
exports._init=(option,suburl,loader)->
	# サーバーから情報を取得
	ss.rpc "users.myData", (user)->
		console.log user
		node=loader null,user
		
	return end:->

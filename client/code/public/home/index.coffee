
exports._init=(option,suburl,loader)->
	unless SS.client.app.getId()
		# ログインが必要
		SS.client.app.startURL loader.parent, "/login",{to:"/home"}
		return
	node=loader null	# テンプレートに渡す
	
	# 中に子を用意
	child=document.createElement "div"
	node.appendChild child
	cont = SS.client.app.startURL child,"/home/info"
	
	loader.controller.urlFilter /^\/home\/(.+)$/,(result)->
		SS.client.app.startURL child,result[0]

	
		
	return end:->


exports._init=(option,suburl,loader)->
	app=require '/app'
	console.log app.getId()
	unless app.getId()
		# ログインが必要
		app.startURL loader.parent, "/login",{to:"/home"}
		return
	node=loader null	# テンプレートに渡す
	
	# 中に子を用意
	child=document.createElement "div"
	node.appendChild child
	cont = app.startURL child,"/home/info"
	
	loader.controller.urlFilter /^\/home\/(.+)$/,(result)->
		app.startURL child,result[0]

	
		
	return end:->

# option:{}
exports._init=(option,suburl,loader)->

	# まずユーザーを探す
	query={}
	if result=suburl.match /\/id\/(\w+)$/
		# IDが渡された系
		query._id=result[1]	# IDで探してもらう
	else
		query.id=suburl.slice 1
		
	app=require '/app'
			
	ss.rpc "users.profile",query,(obj)->
		if obj.error?
			# エラー
			app.error loader.parent,{message:obj.error}
			return
		node=loader null,obj.user	# ユーザーデータ
		
		# 正男一覧を表示してあげる
		app.startURL $("#masaosarea"),"/masaolist/user/#{obj.user.id}",{user_id:obj.user._id,title:"#{obj.user.name}の正男一覧"}
		
	
	return end:->
	
# option:{user_id?:String}
exports._init=(option={},suburl,loader)->

	# 正男一覧を表示するぞ！
	query={}
	page=0
	
	if option.user_id
		# ObjectIDが分かっている
		query.user_id=option.user_id
	else if result=suburl.match /^\/user\/(\w+)$/
		# ユーザーIDで正男一覧
		query.userid=result[1]
	
	ss.rpc "masao.masaolist",query,(docs)->
		console.log docs
		node=loader null,{masaos:docs}
	return end:->
	

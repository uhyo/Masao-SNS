# option:{user_id?:String, title?:String}
exports._init=(option={},suburl,loader)->

	# リソース一覧を表示するぞ！
	query={}
	sort={}
	page=0
	title=option.title
	
	if option.user_id
		# ObjectIDが分かっている
		query.user_id=option.user_id
	else if result=suburl.match /^\/user\/(\w+)$/
		# ユーザーIDで
		query.userid=result[1]
	
	ss.rpc "resource.resourcelist",query,sort,(docs)->
		node=loader null,{resources:docs,title:title}
	return end:->
	

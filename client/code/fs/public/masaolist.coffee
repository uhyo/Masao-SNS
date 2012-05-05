# option:{user_id?:String, title?:String}
exports._init=(option={},suburl,loader)->

	# 正男一覧を表示するぞ！
	query={}
	sort={}
	page=0
	title=option.title
	
	if option.user_id
		# ObjectIDが分かっている
		query.user_id=option.user_id
	else if result=suburl.match /^\/user\/(\w+)$/
		# ユーザーIDで正男一覧
		query.userid=result[1]
	else if result=suburl.match /^\/series\/(\w+)$/
		# シリーズIDで正男一覧
		query.series=result[1]
	else if suburl=="/latest"
		# 新しい順
		sort.uptime=-1	#新しい順
		title ?= "最新の正男"
	else if suburl=="/rank/view"
		# 閲覧数
		sort.viewcount=-1	# 閲覧数多いじゅん
		title ?= "閲覧数ランキング"
	
	ss.rpc "masao.masaolist",query,sort,(docs)->
		node=loader null,{masaos:docs,title:title}
	return end:->
	

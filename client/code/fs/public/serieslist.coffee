# option:{user_id?:String, title?:String, usage?:String,select?:Function}
exports._init=(option={},suburl,loader)->

	# シリーズ一覧を表示するぞ！
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
		
	if option.usage
		query.usage=option.usage
	
	ss.rpc "series.serieslist",query,sort,(docs)->
		node=loader null,{myseries:docs,title:title, select:!!option.select}
		
		if option.select?
			$(node).on "click",".seriesselectbutton", (je)->
				option.select JSON.parse je.target.dataset.series
	return end:->
	
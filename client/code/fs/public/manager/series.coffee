# option:{}
exports._init=(option,suburl,loader)->
	app=require '/app'

	seriesid=suburl.slice 1	#/を取り除く
	app.assertLogin loader.parent,"シリーズ管理を行うにはログインして下さい。",->
		ss.rpc "series.getSeries",{_id:seriesid},(series)->
			unless series?
				app.error loader.parent,{message:"そのシリーズは存在しません"}
				return
			
			node=loader null,series
		
	return end:->
	

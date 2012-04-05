# option:{}
exports._init=(option,suburl,loader)->

	masaoid=parseInt suburl.slice 1	#/を取り除く
	
	node=loader()
	
	mode="time"	#ランキングモード
	page=0		# 表示
	
	load masaoid,mode,page
	
	#リンク制御
	$(node).click (je)->
		if $(je.target).is "a"
			# コマンド取得
			if result=je.target.href.match /#(\w+)$/
				switch result[1]
					when "time","rank"
						mode=result[1]	# 並び替えを変える
					when "prev"
						#前のページ
						page--
						page=0 if page<0
					when "next"
						#次
						page++
					else
						return
				je.preventDefault()
				#読む
				load masaoid,mode,page
						
	
	return {
		end:->
		# ランキング一覧を表示しなおしてほしい
		refresh:->load masaoid,mode,page
	}
	
#type: "time","rank" page:0,1,2,...
load=(masaoid,type,page)->
	page=0 if page<0
	
	ss.rpc "masao.getComments",masaoid,type,page,(docs)->
		if docs.error?
			app=require '/app'
			app.error $("#masaocommentsarea"),{message:docs.error}
			return
		area=$("#masaocommentsarea").empty()
		docs.forEach (doc)->
			doc.time=new Date doc.time	#timeが文字列化しているので直す
			
			area.append $ JT["tmp-masao-comment"] doc	#tmp-masao-commentを読み込む

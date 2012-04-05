#option:{masaoid:Number,object:[HTMLObjectElement],callback?:(投稿したときのコールバック)}
#コメントフォーム
exports._init=(option,suburl,loader)->
	
	masaoid=option.masaoid
	masaoobject=option.object
	
	app=require '/app'
	unless masaoid?
		# 不正
		app.error loader.parent,{title:"エラー",message:"正男IDが不正です"}
		return
	unless masaoobject?
		app.error loader.parent,{title:"エラー",message:"正男オブジェクトが不正です"}
		return
	node=loader "special-masao-comment"
	# 送信フォームイベント
	$("#masaocommentform").submit (je)->
		je.preventDefault()
		form=je.target
		# サーバーに送るクエリ
		query=
			_id:masaoid	#正男ID（数値）
			comment:form.elements["comment"].value
			score:null
		
		if form.elements["sendhighscore"].checked
			#ハイスコアを送る
			query.score=masaoobject.getHighscore()
			
		ss.rpc "masao.comment",query,(result)->
			if result.error?
				# エラー
				app.error loader.parent,{message:result.error}
				return
			#成功
			app.message loader.parent,{message:"コメントを投稿しました。"}
			#投稿したらコールバックがあるかも
			option.callback?()
		
	return end:->

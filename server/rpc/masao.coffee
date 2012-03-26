# Server-side Code

dbutil=require '../dbutil.coffee'

exports.actions = (req,res,ss)->

	req.use 'session'

	# 正男オブジェクトをひとつ得る
	#query:{_id:"_id文字列"}または{number:数字}
	#エラー時: {error:"～"}
	getMasao:(query)->
		unless query?
			res {error:"クエリが不正です"}
			return
		M.masao (coll)->
			q={}
			if query.number
				q.number=query.number
			else if query._id
				# _idの文字列
				q._id=dbutil.get_id query._id
			coll.findOne q,(err,doc)->
				if err?
					throw err
				unless doc?
					res {error:"その正男は存在しません"}
				else
					res doc
	# 正男情報を変更する
	#query:{number:1,title:"foo",author:"bar",description:"hoge"}
	#res {error?:String, success?:true}
	manage:(query)->
		unless query?
			res error:"クエリが不正です"
			return
		M.masao (coll)->
			q=
				number:parseInt query.number
			coll.findOne q,(err,doc)->
				if err?
					throw err
				unless doc?
					res error:"その正男は存在しません"
				else
					unless doc.user._id==req.session._id	# 正男の所持者であるかどうか
						res error:"権限がありません"
					else
						up=
							$set:
								title:query.title
								author:query.author
								description:query.description
						coll.update q,up,(err)->
							if err?
								throw err
							res success:true
	# 正男をアップロードする
	#res {error?:String, success?:true, number:String(アップロードされた正男の番号)}
	upload:(doc)->
		unless doc?
			res error:"正男が不正です"
			return
		unless req.session.userId
			res error:"ログインして下さい"
			return
		# 書式チェック
		unless doc.title&&doc.author&&doc.description
			res error:"情報を入力して下さい"
			return
		unless doc.resources? && (typeof doc.resources=="object")
			res error:"リソース情報が不正です"
			return
		unless doc.masao?
			res error:"正男が不正です"
			return
		unless doc.masao.tags?
			res error:"正男のタグ情報がありません"
			return
		unless doc.masao.params?
			res error:"正男のパラメータ情報がありません"
			return
		unless doc.masao.type && doc.masao.version
			res error:"正男のパラメータ情報がありません"
			return
		doc.masao.tags=
			script:doc.masao.tags.script
			header:doc.masao.tags.header
			footer:doc.masao.tags.footer
		
		#OK
		serveNewNumber (num)->
			doc.number=num
			# 自分の情報も添える
			M.users (coll)->
				coll.findOne {id:req.session.userId}, (err,user)->
					if err?
						res {error:err}
						return
					doc.user=
						_id:user._id
						name:user.name
					M.masao (coll2)->
						coll2.insert doc,(err,docs)->
							res {
								success:true
								number:doc.number
							}
	
# 正男の連番を得る
serveNewNumber=(cb)-> require('../dbutil').count "masaoNumber",cb

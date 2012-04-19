# Server-side Code

dbutil=require '../dbutil.coffee'
userutil=require '../user.coffee'

exports.actions = (req,res,ss)->

	req.use 'session'

	# リソースをアップロードする
	#res {error?:String, success?:true, _id:String(アップロードされたリソースのObjectID)}
	upload:(query)->
		# ここまだ書いてないよ！
		#query: type,name,size,usage,comment,data
		unless query.type? && query.size && query.name && query.usage? && query.comment? && query.data?
			res error:"データが不正です"
			return
		#data: base64 encoded
		doc=
			type:query.type
			size:query.size
			name:query.name
			usage:query.usage
			comment:query.comment
			user:dbutil.get_id req.session._id
			uptime:new Date
			data:MongoDB.Binary new Buffer query.data,'base64'
			
		M.resources (coll)->
			coll.insert doc,{safe:true},(err,docs)->
				if docs[0]?
					res {
						success:true
						_id:docs[0]._id.toString()
					}
	getResource:(query)->
		unless query?
			res error:"クエリが不正です"
			return
		#{query: _id, data?}
		M.resources (coll)->
			coll.findOne {_id:dbutil.get_id query._id},(err,doc)->
				unless doc?
					res error:"そのリソースは存在しません"
					return
				if query.data
					# データも欲しい
					doc.data= doc.data.buffer.toString "base64"
				else
					delete doc.data
				M.users (coll2)->
					# ユーザーデータもあげる
					coll2.findOne {_id:doc.user},(err,user)->
						if !user?
							res error:"アップロード者のデータが取得できません"
							return
						userutil.publishFilter user
						doc.user=user
						res doc
	resourcelist:(query,sort)->
		unless query?
			res error:"クエリが不正です"
			return
		#userの_idを取得したら次へ
		ne=(user_id)->
			M.resources (coll)->
				q={}
				if user_id?
					q.user=user_id
				query.page ?= 0	#何ページ目か
				query.page=0 if query.page<0
				# query.length: 1ページに表示する件数
				coll.find(q).sort(sort).limit(Math.min(query.length,config.resourcelist.pagemaxlength)).skip(query.page).toArray (err,docs)->
					# docsを送る
					docs.forEach (x)->
						delete x.data
					res docs

		# ユーザーを取得
		if query.user_id
			# ObjectIDが与えられた
			ne dbutil.get_id query.user_id
		else if query.userid
			# ユーザーIDが与えられた
			M.users (coll)->
				coll.findOne {id:query.userid},(err,doc)->
					unless doc?
						res error:"そのユーザーは存在しません"
						return
					ne doc._id	#ObjectID
		else
			ne null

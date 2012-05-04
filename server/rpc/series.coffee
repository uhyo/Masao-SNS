# Server-side Code

dbutil=require '../dbutil.coffee'
userutil=require '../user.coffee'

exports.actions = (req,res,ss)->

	req.use 'session'
	
	# query:{name:String}
	# res {error?:String, success?:true, _id:String}
	newseries:(query)->
		unless query?
			res error:"クエリが不正です"
			return
		unless req.session._id
			res error:"ログインして下さい"
			return
			
		M.users (coll)->
			coll.findOne {_id:dbutil.get_id req.session._id}, (err,user)->
				if err?
					res error:err
					return
				unless user?
					res error:"不正なユーザーです"
					return
				doc=
					name:query.name
					user:
						_id:user._id
						name:user.name
					masao:[]
					resources:{}
					uptime:new Date
				
				M.series (coll2)->
					coll2.insert doc,{safe:true},(err,docs)->
						if err?
							res error:err
							return
						res {
							success:true
							_id:String docs[0]._id
						}
					
		
	getSeries:(query)->
		unless query?
			res error:"クエリが不正です"
			return
		if query._id?
			query._id=dbutil.get_id query._id
		M.series (coll)->
			coll.findOne query,(err,doc)->
				res doc
				
	
	# query:{_id, name, resources}
	#res {error?:"" success?:true}
	manage:(query)->
		unless query?
			res error:"クエリが不正です"
			return
		unless query.name && query.resources
			res error:"データが不足しています"
			return
		M.series (coll)->
			
			doc=
				$set:
					name:query.name
					resources:query.resources
			
			coll.update {_id:dbutil.get_id(query._id),"user._id":dbutil.get_id(req.session._id)},doc,{safe:true},(err)->
				res success:true

	serieslist:(query,sort)->
		unless query?
			res error:"クエリが不正です"
			return
		#userの_idを取得したら次へ
		ne=(user_id)->
			M.series (coll)->
				q={}
				if user_id?
					q["user._id"]=user_id
					
				query.page ?= 0	#何ページ目か
				query.page=0 if query.page<0
				# query.length: 1ページに表示する件数
				coll.find(q).sort(sort).limit(Math.min(query.length,config.serieslist.pagemaxlength)).skip(query.page).toArray (err,docs)->
					# docsを送る
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

# Server-side Code
crypto=require 'crypto'
dbutil=require '../dbutil.coffee'

exports.actions = (req,res,ss)->

	req.use 'session'

	#query: {id: String, password: String(raw) }
	#cb: nullなら成功 それ以外はエラーメッセージ
	login: (query)->
		# usersコレクションから一致するものを探す
		unless query.id
			res "ユーザーIDが不正です"
			return
		M.users (coll)->
			coll.findOne {id: query.id},(err,user)->
				unless user?
					res "ユーザーIDまたはパスワードが違います。"
					return
				# パスワードをハッシュ化する
				hashedpassword= cryptopassword query.password,user.password
				if hashedpassword==user.password
					# パスワードが一致
					req.session.setUserId user.id
					# 内部IDも覚えておく
					req.session._id=String user._id	#Stringで保存注意
					req.session.save ->
						res null	# 成功
					# IPアドレスと最終ログイン時間を上書きする
					
					ip=req.clientIp
					if ip?
						coll.update {id:user.id},{$set:{ip:ip, lasttime: new Date()}}
					
				else
					res "ユーザーIDまたはパスワードが違います。"
	
	# 新規登録
	#query: {id: String, password: String(raw) }
	#cb null/エラーメッセージ（あれば）
	newuser: (query)->
		if !(isValidId query.id) && !(isValidPassword query.password)
			res "ユーザーIDかパスワードが不正です。"
			return
		M.users (coll)->
			coll.findOne {id: query.id},(err,user)->
				if user?
					res "そのユーザーIDは使用されています。"
					return
				###
				# 同じIPアドレスで
				limdate=new Date()
				limdate.setTime limdate.getTime()-SS.config.user.newuserWait*1000	# これより最近にログインしていたらだめ
				ip=req.clientIp
				coll.findOne {ip:ip, lasttime:{$gt: limdate}},(err,user)->
					console.log user
					if user?
						cb "まだ新規登録ができません。"
						return
					# ユーザーを登録
					hashedpassword = cryptopassword query.password
					user=
						id:query.id
						name:query.id
						password:hashedpassword
						permission:[]
						ip:ip
						lasttime:new Date()
						
					coll.insert user,{safe:true},(err,docs)->
						# 成功
						cb null
				###
	
	# 自分のユーザーデータをもらう
	# cb: ユーザーデータ/null（なければ）
	myData: ->
		unless req.session.userId?
			# ログインしていない
			res null
			return
		M.users (coll)->
			coll.findOne {id:req.session.userId}, (err,user)->
				if err?
					res {error:err}
					return
				publishFilter user
				res user
	# 自分のユーザーデータを変更
	# cb: null/エラーメッセージ（あれば）
	changeMyProfile: (query)->
		M.users (coll)->
			coll.findOne {id:req.session.userId},(err,user)->
				unless user?
					res "ユーザーIDが不正です。"
					return
				hashedpassword=cryptopassword query.password,user.password
				if hashedpassword==user.password
					# パスワードが一致した
					setquery={}
					if query.name?
						setquery.name=query.name
					if query.newpassword?
						if query.newpassword!=query.newpassword2
							res "新しいパスワードが一致しません。"
							return
						setquery.password= cryptopassword query.newpassword
				
					coll.update {id:user.id},{$set:setquery},{safe:true},(err)->
						res null	# 成功した
						
				else
					res "パスワードが間違っています。"
	# 自分の投稿した正男を得る（配列で）
	myMasao: ->
		unless req.session.userId
			res error:"ログインして下さい"
			return
		M.masao (coll)->
			coll.find {"user._id":dbutil.get_id req.session._id},(err,cursor)->
				if err?
					throw err
				cursor.toArray (err,docs)->
					docs.forEach (x)->
						delete x.masao	# 本体はいらない
					res docs
	# 他人のホームを見る
	#query: _id:String(ObjectID) または id:(userid)
	#res {error:String} / {user:doc}
	profile:(query)->
		q={}
		if query._id
			q._id=dbutil.get_id query._id
		else
			q.id=query.id
		M.users (coll)->
			coll.findOne q,(err,doc)->
				unless doc?
					res error:"そのユーザーは存在しません"
					return
				# 余計な情報削除
				publishFilter doc
				res {user:doc}
				
			

#raw password -> hashed password
cryptopassword=(raw,salt=null)->
	unless salt?
		salt=makesalt()
	salt="#{salt}00000".slice 0,5	# 先頭から5文字
	
	sha256 = crypto.createHash "sha256"
	sha256.update "#{salt}#{raw}"
	return "#{salt}#{sha256.digest "base64"}"	#結果を返す

# saltは5文字です
makesalt= ->
	strs="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTVUXYZ0123456789_"
	le=strs.length
	[0..4].map((x)->
		strs[Math.floor Math.random()*le]
	).join ""
	
# ユーザーID・パスワードがvalidがどうか確かめる
isValidId=(id)->/^\w+$/.test id
isValidPassword=(pass)->/^\w+$/.test pass

# ユーザーデータをクライアント側に公開する形に修正
publishFilter=(user)->
	delete user.password
	delete user.ip
	delete user.lasttime

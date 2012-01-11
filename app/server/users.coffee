# Server-side Code
crypto=require 'crypto'

exports.actions =
	#query: {id: String, password: String(raw) }
	#cb: nullなら成功 それ以外はエラーメッセージ
	login: (query, cb)->
		# usersコレクションから一致するものを探す
		unless query.id
			cb "ユーザーIDが不正です"
			return
		M.users (coll)=>
			coll.findOne {id: query.id},(err,user)=>
				unless user?
					cb "ユーザーIDまたはパスワードが違います"
					return
				# パスワードをハッシュ化する
				hashedpassword= cryptopassword query.password,user.password
				if hashedpassword==user.password
					# パスワードが一致
					@session.setUserId user.id
					cb null	# 成功
					# IPアドレスと最終ログイン時間を上書きする
					ip=getIPaddress @request
					if ip?
						coll.update {id:user.id},{$set:{ip:ip, lasttime: new Date()}}
				else
					cb "ユーザーIDまたはパスワードが違います"
	
	# 新規登録
	#query: {id: String, password: String(raw) }
	newuser: (query,cb)->
		if !(isValidId query.id) && !(isValidPassword query.password)
			cb "ユーザーIDかパスワードが不正です"
			return
		M.users (coll)=>
			coll.findOne {id: query.id},(err,user)=>
				if user?
					cb "そのユーザーIDは使用されています"
					return
				# 同じIPアドレスで
				limdate=new Date()
				limdate.setTime limdate.getTime()-SS.config.user.newuserWait*1000	# これより最近にログインしていたらだめ
				ip=getIPaddress @request
				coll.findOne {ip:ip, lasttime:{$gt: limdate}},(err,user)->
					console.log user
					if user?
						cb "まだ新規登録ができません"
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
	
	# 自分のユーザーデータをもらう
	myData: (cb)->
		unless @session.user_id?
			# ログインしていない
			cb null
			return
		M.users (coll)=>
			coll.findOne {id:@session.user_id}, (err,user)->
				if err?
					cb {error:err}
					return
				publishFilter user
				cb user
				
					
				

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
	
# IPアドレスを取得 getIPaddress(@request)
getIPaddress=(request)->
	SS.io.sockets.sockets[request.socket_id]?.handshake.address.address
# ユーザーID・パスワードがvalidがどうか確かめる
isValidId=(id)->/^\w+$/.test id
isValidPassword=(pass)->/^\w+$/.test pass

# ユーザーデータをクライアント側に公開する形に修正
publishFilter=(user)->
	delete user.password
	delete user.ip
	delete user.lasttime

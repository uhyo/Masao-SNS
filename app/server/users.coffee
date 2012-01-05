# Server-side Code
crypto=require 'crypto'

exports.actions =
	#query: {id: String, password: String(raw) }
	#cb: nullなら成功 それ以外はエラーメッセージ
	login: (query, cb)->
		# usersコレクションから一致するものを探す
		M.users (coll)=>
			coll.findOne {id: query.id},(user)=>
				unless user?
					cb "ユーザーIDまたはパスワードが違います"
					return
				# パスワードをハッシュ化する
				hashedpassword= cryptopassword query.password,user.password
				if hashedpassword===user.password
					# パスワードが一致
					@session.setUserId user.id
					cb null	# 成功
					# IPアドレスを上書きする
					ip=SS.io.sockets.sockets[@request.socket_id]?.handshake.address.address
					if ip?
						coll.update {id:user.id},{$set:{ip:ip}}
				else
					cb "ユーザーIDまたはパスワードが違います"
	
	# 新規登録
	newuser: (query,cb)->



#raw password -> hashed password
cryptopassword=(raw,salt=null)->
	unless salt?
		salt=makesalt()
	salt="#{salt}00000".slice 0,5	# 先頭から5文字
	
	sha256 = crypto.createHash "sha256"
	sha256.update "#{salt}#{raw}"
	return salt+sha256.digest "base64"	#結果を返す

# saltは5文字です
makesalt= ->
	strs="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTVUXYZ0123456789_"
	le=strs.length
	[0..4].map((x)->
		strs[Math.floor Math.random()*le]
	).join ""

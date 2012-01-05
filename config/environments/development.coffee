exports.config=
  # DBの設定
  db:
    mongo:
      name:"masaosns"	#DB name
      host:"localhost"	#server
      port:27017	#port

      #db user
      user:"test"
      password:"test"
  # ユーザー関係の設定
  user:
    # 新しいユーザーは、同じIPアドレスで直近newuserWait秒の間にログインしていたらできない
    newuserWait:86400

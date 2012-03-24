# DBの設定
exports.mongo=
  name:"masaosns"
  host:"localhost"
  port:27017
  
  #db user
  user:"test"
  password:"test"

# ユーザー関係の設定
exports.user=
  # 新しいユーザーは、同じIPアドレスで直近newuserWait秒の間にログインしていたらできない
  newuserWait:86400

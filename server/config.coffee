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
  
# 正男コメントの設定
exports.masaocomment=
  # コメントの最大長さ（文字数）
  maxlength:100
  # 1ページのコメント表示数
  pagelength:10

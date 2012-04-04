# 正男につけられたコメントについて
`masaocomments`コレクションに保存。

## フォーマット
    {
      masaoid:Number,	//正男の_id
      user:ObjectID,	//ユーザーのObjectID
      name:"na2hiro",	//ユーザーの名前
      comment:"ユーザーのコメント",
      time:Date,	//投稿日時
      score:Number/null	//スコア（非公開の場合はnull）
    }

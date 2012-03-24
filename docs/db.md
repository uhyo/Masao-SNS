# データベースについて
使用DB: MongoDB

## データベース設定
/server/config.coffee

## 使用するコレクション
/server/db.coffee 内に列挙すること

## データベースの利用
グローバル変数Mを用いて次のようにコレクションを得る。
    #例) usersコレクションを使う
    M.users (coll)->
      coll.insert {},...
グローバル変数MongoDBに生のオブジェクトが入っている（詳細は`/server/db.coffee`を参照のこと）

# ユーザーについて
## ユーザーが保持する情報
* `id` ユーザーID（半角英数字+アンダーバー可能(`\w`)
* `name` 表示名(screen_name) 自由な文字列
* `password` ハッシュ化済みパスワード
* `permission` 権限 権限を表す文字列の配列
* `ip` IPアドレス ログイン時に上書きする

### 権限一覧
(未定)


## データベース
コレクション: `users`



### 書式
    {
      id: "ユーザーID"
      name: "名前"
      password: "ハッシュ化されたパスワード"
      ip: "IPアドレス"
      
      permission: ["権限1","権限2"]
    }
    
# パスワードについて
ハッシュ化して保存する。

## ハッシュ化方法
5文字からなるsalt（`abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTVUXYZ0123456789_`から5文字）。

saltを先頭に付加してsha256でハッシュ化したのち、saltを先頭に付加したものを結果とする。結果はbase64で保存する。

# ページの仕様
SocketStreamでは、まず最初に`app/client/app.coffee`内のメソッド_initが呼ばれることになっている。

この_initでは、現在のURLに合わせて対応するページの読み込みが行われる。

**注意：_init.coffeeというファイルがあると誤認されるので作らないこと**

## ページの仕組み
ページは、ページを構成する一つのテンプレートと一つのスクリプト（.coffeeファイル）によって成り立つ。

これらは、 `client/public/`以下と、`views/public`以下にそれぞれ入っている。例えば`/foo/bar` というページが呼び出されたとき、それぞれ`client/public/foo/bar.coffee`と`views/public/foo/bar.jade`を用いてページが構成される。

スクリプト側から任意のURLを呼び出したい場合、`SS.client.app.startURL`を用いる。

## 可変URLへの対応
`/user/na2hiro`など可変的なURLに対応するためには、この例の場合だとuserディレクトリは作らずに、`client/public/user.coffee`、`views/public/user.jade`から読み出す。この動作は、`client/public/user`ディレクトリなどがない場合に引き起こされる。

この場合、残りの`/na2hiro`の部分はuser.coffeeにパラメータとして渡されるので、それを用いて処理を行う。

また、`/foo/bar`と`/foo`別のページを表示させたい場合には、fooフォルダとfoo.coffeeは同時用意することはできないので、fooフォルダを用意して`/foo`のときは`client/public/foo/index.coffee`と`views/public/foo/index.coffee`というファイルに対応する。

## 特別なページ
トップページや404のページなど特別なページは、public/以下に存在しない。

例えばトップページは、`client/special/top.coffee`と`views/special/top.jade`にある。

これらのページを使用したい場合、スクリプト中で`SS.client.special.top`のようにして直接オブジェクトのありかを記述する。例えばトップページは、`client/app.coffee`内で特別に記述されている。

テンプレートについては、`client/special/top.coffee`内で使用するテンプレートを記述できるので、そこに`special-top`のようにして記述している。404についても同様。

404のページは、例えば`/foo`というURLでそもそも`client/public/foo.coffee`がなかった場合にも`client/special/top.coffee`が呼び出されることを利用して、パラメータとして渡される残りのURL（前述）に何か残っているかどうかを確認して何かあれば存在しないURLだと判断し、そこから`SS.client.special["404"]`という記述で呼び出している。

# ログインについて
ログインした場合、`SS.client.app.setId`メソッドによって現在のユーザーIDが記憶されるが、サーバー側でも独自に記憶している。

現在のIDは`SS.client.app.getId()`によって取得できるので、nullかどうかでログイン済みかどうか判定できる。

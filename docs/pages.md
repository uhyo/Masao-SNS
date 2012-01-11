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

この場合、残りの`/na2hiro`の部分はuser.coffeeにパラメータとして渡される（後述）ので、それを用いて処理を行う。

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

# スクリプトからの利用
`SS.client.app.startURL parent, url[, option]`で任意のURLで表されるページを読み込むことができる。内部的に`SS.client.app.startProcess`を呼び出すが、URLで表されないような特殊なページを読み込む際にこれを直接呼び出すことも可能である。

`parent`はページ表示領域の親となるノード、`url`はURL。

## _initの仕様
`_init`の基本的な書式は次のようになる。

    exports._init=(option,suburl,loader)->
      node=loader()

`option`は`SS.client.app.startURL`に渡されたオプションである。

`suburl`は、上記「可変URLへの対応」で余った部分のURLが渡される。例えば、`/user/na2hiro`で`client/public.user.coffee`に渡される場合、余った`"/na2hiro"`が渡される。

`loader`は関数である。この関数を呼び出すと自動で適切な位置にテンプレートが読み込まれる。第一引数にテンプレート名（例：`special-404`などを渡すと、上記のURL解析によって探し当てられたテンプレートではなくそちらが読み込まれる。第二引数があれば、それは`jQuery.tmpl`に渡されるオプションとなる。

また、`loader`は拡張された関数オブジェクトであり、独自のプロパティをもつ。`loader.parent`は、`SS.client.app.startURL`に渡された`parent`である。自分自身を書き換えるときに使用するとよい。

また、`loader.controller`にはユーティリティメソッドが入っている。

## controllerのメソッド
### urlFilter
`loader.urlFilter regexp[, func]`

そのページ内でリンクがクリックされた場合、第一引数に渡した正規表現にそのURLがマッチすれば（ドメイン名などは除かれ、正規表現と比較されるのは`/foo/bar`という形のURLである）、第二引数に渡した関数が呼ばれる。その際の引数は、`match`メソッドでマッチさせた際の引数である。

また、引数が省略された場合、その領域内のみ新しいページに書き換える動作になる。デフォルトではリンクがクリックされるとページ全体が書き換えられるが、書き換えを一部分にとどめる効果がある。


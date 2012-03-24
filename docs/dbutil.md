# DB utility
使用DB: MongoDB

## 連番カウンタ
`counters`コレクションに以下のようなオブジェクト（自動生成）。
  {
    id:"foo",
    number:3
  }

`dbutil.count`呼び出しで使用可能。最初は1。

現在使用されているやつ一覧：
* masaoNumber : 正男の連番

# logsについて
コレクション`logs`Capped Collectionである。

Capped Collectionでは、DB内のデータは一定量を越えると古いほうから消されていく。

またデータ取得時は挿入順になることが保証されている。

## logsの中身
いろいろなログが入る。

`type`フィールドで種類を判別する。

### 正男閲覧ログ
    {
      type:"masaoview"
      masaoid:Number(正男の_id)
      user?:ObjectID(ユーザーの_id / 未ログインならばnull）
      time:Date(閲覧日時)
    }

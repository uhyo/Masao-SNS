# リソースについて
リソース1つにつき1ドキュメントをコレクション`resources`に入れる。
その`_id`で識別する。

## アクセス
`/resources/(_id)`(HTTPでファイルが返される)

## DBのデータ
    {
      type:"image/gif",	//ファイルのMIMEタイプ。""の場合は不明
      size:12345,	//ファイルサイズ
      user:ObjectID,	//アップロードユーザーのObjectID
      uptime:Date,	//アップロード時刻
      name,"pattern.gif",//もともとのファイル名
      usage:"filename_pattern",	//使用法（強制力はないと思う）。 ""とかnullでもいい
      comment:"コメントメント",//コメント。""でもよい
      
      data:BinData	//ファイルの中身
    }
    
## usage
* filename_pattern
* filename_ending
* filename_gameover
* filename_title
* script

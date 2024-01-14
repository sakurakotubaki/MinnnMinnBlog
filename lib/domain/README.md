# microCMSのAPIから情報を取得

国産のCMSであるmicroCMSを使って、ブログのAPIを作成して`JSON`のデータを生成させて、他のアプリケーションから呼び出してみる。

## これがAPI設計書
APIのBodyについて:

このJSONデータは、microCMSから取得したブログの情報を表しています。各ブログ記事はcontents配列の中にオブジェクトとして格納されており、各オブジェクトは記事の詳細情報（id、createdAt、updatedAt、publishedAt、revisedAt、title、content、eyecatch、category）を持っています。

また、totalCount、offset、limitはページネーションに関する情報を提供します。totalCountは全記事数を、offsetは現在のページの開始位置を、limitは1ページあたりの記事数を表しています。

```json
{
    "contents": [
        {
            "id": "7zd__8nof",
            "createdAt": "2024-01-07T02:04:32.995Z",
            "updatedAt": "2024-01-07T02:04:32.995Z",
            "publishedAt": "2024-01-07T02:04:32.995Z",
            "revisedAt": "2024-01-07T02:04:32.995Z",
            "title": "taiseさんとランチしました",
            "content": "<p>横浜の地下街でご飯食べました</p><p>横浜に行ったときになかなかお会いできなかったtaiseさんにお会いすることができました。オフラインのオフ会は楽しかったです〜</p>",
            "eyecatch": {
                "url": "https://images.microcms-assets.io/assets/6cef73a6dc944b7b92b08d80f5fd3e07/6df7f47eb94f4e91a61976f20364acf8/taise.jpeg",
                "height": 400,
                "width": 400
            },
            "category": null
        },
        {
            "id": "aych77r7_lw",
            "createdAt": "2024-01-06T12:04:26.552Z",
            "updatedAt": "2024-01-06T12:04:26.552Z",
            "publishedAt": "2024-01-06T12:04:26.552Z",
            "revisedAt": "2024-01-06T12:04:26.552Z",
            "title": "yuiさんとケーキ屋さんとケーキ屋さんへ行きました。",
            "content": "<p>自由が丘のお店を回った</p><p>yuiさんと２人で自由が丘の有名なケーキ店のパリセヴェイユとモンサンクレールクレールへ行きました。</p><p>リッチなお味でした。</p>",
            "eyecatch": {
                "url": "https://images.microcms-assets.io/assets/6cef73a6dc944b7b92b08d80f5fd3e07/5d40dec6ab3541ab8f8bfd48da1c838d/yui.jpeg",
                "height": 326,
                "width": 326
            },
            "category": null
        },
        {
            "id": "2xbbrx1i1",
            "createdAt": "2024-01-06T11:07:14.848Z",
            "updatedAt": "2024-01-06T11:07:14.848Z",
            "publishedAt": "2024-01-06T11:07:14.848Z",
            "revisedAt": "2024-01-06T11:07:14.848Z",
            "title": "minnさんの転職記念日",
            "content": "<p>20:30の渋谷</p><p>今日は渋谷の和食店で、minnさんの転職祝いをしました。</p><p>お酒は飲み放題。ノドグロが美味しかったです。</p>",
            "eyecatch": {
                "url": "https://images.microcms-assets.io/assets/6cef73a6dc944b7b92b08d80f5fd3e07/352e69f95ee74db5ace0daad78699800/minn.jpeg",
                "height": 460,
                "width": 460
            },
            "category": null
        }
    ],
    "totalCount": 3,
    "offset": 0,
    "limit": 10
}
```

ネストしたJSONのデータを取得する場合は、モデルクラスもネストしないといけない。
これは動かしてみないと、どんな書き方が良いかわからない???
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blog_state.freezed.dart';
part 'blog_state.g.dart';

// ネストしたJSONからデータを取得するモデルの設計
@freezed
class ResponseModel with _$ResponseModel {
  factory ResponseModel({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? publishedAt,
    String? revisedAt,
    String? title,
    String? content,
    Eyecatch? eyecatch,
    String? category,
  }) = _ResponseModel;

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
    _$ResponseModelFromJson(json);
}
// ブログのコンテンツを取得するモデルの設計
@freezed
class Content with _$Content {
  factory Content({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? publishedAt,
    String? revisedAt,
    String? title,
    String? content,
    Eyecatch? eyecatch,
    String? category,
  }) = _Content;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);
}
// アイキャッチ画像を取得するモデルの設計
@freezed
class Eyecatch with _$Eyecatch {
  factory Eyecatch({
    required String url,
    int? height,
    int? width,
  }) = _Eyecatch;

  factory Eyecatch.fromJson(Map<String, dynamic> json) =>
      _$EyecatchFromJson(json);
}
```

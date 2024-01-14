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

/// [書き方変えたらいらなくなった???]
// ブログのコンテンツを取得するモデルの設計
// @freezed
// class Content with _$Content {
//   factory Content({
//     String? id,
//     String? createdAt,
//     String? updatedAt,
//     String? publishedAt,
//     String? revisedAt,
//     String? title,
//     String? content,
//     Eyecatch? eyecatch,
//     String? category,
//   }) = _Content;

//   factory Content.fromJson(Map<String, dynamic> json) =>
//       _$ContentFromJson(json);
// }

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

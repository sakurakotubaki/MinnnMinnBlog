// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResponseModelImpl _$$ResponseModelImplFromJson(Map<String, dynamic> json) =>
    _$ResponseModelImpl(
      id: json['id'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      publishedAt: json['publishedAt'] as String?,
      revisedAt: json['revisedAt'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      eyecatch: json['eyecatch'] == null
          ? null
          : Eyecatch.fromJson(json['eyecatch'] as Map<String, dynamic>),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$ResponseModelImplToJson(_$ResponseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'publishedAt': instance.publishedAt,
      'revisedAt': instance.revisedAt,
      'title': instance.title,
      'content': instance.content,
      'eyecatch': instance.eyecatch,
      'category': instance.category,
    };

_$EyecatchImpl _$$EyecatchImplFromJson(Map<String, dynamic> json) =>
    _$EyecatchImpl(
      url: json['url'] as String,
      height: json['height'] as int?,
      width: json['width'] as int?,
    );

Map<String, dynamic> _$$EyecatchImplToJson(_$EyecatchImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'height': instance.height,
      'width': instance.width,
    };

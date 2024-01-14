import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onion_architecture/domain/blog_state.dart';
import 'package:onion_architecture/core/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'micro_cms_api.g.dart';
/*
status codeによってエラーを返すEnum。
今回は、HTTP GETだけなので、200かそれ以外かの2つだけ。
*/
enum MicroCMSApiStatus {
  success,
  serverError,
  networkError,
}
// ロジックを書いてないインターフェースを作って祖結合にしてみた。
abstract interface class MicroCMS {
  Future<List<ResponseModel>> getCategories();
}
// Riverpod1系だと、Providerを使う。
// final microCMSApiImplProvider = Provider<MicroCMSApiImpl>((ref) {
//   return MicroCMSApiImpl();
// });

// 状態が破棄されないように、keepAliveをtrueにしている。
@Riverpod(keepAlive: true)
MicroCMSApiImpl microCMSApiImpl(MicroCMSApiImplRef ref) {
  return MicroCMSApiImpl();
}

// MicroCMSApiImplクラスは、MicroCMSインターフェースを実装している。
class MicroCMSApiImpl implements MicroCMS {
  final baseUrl = 'https://xityyp5xvg.microcms.io/api/v1/blogs';

  @override
  Future<List<ResponseModel>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {// .envファイルからAPIキーを取得
          'X-MICROCMS-API-KEY': dotenv.env['MICROCMS_API_KEY'] ?? '',
        },
      );
      // Enumを使って、ステータスコードによってエラーを返す。
      switch (response.statusCode) {
        case 200:// 200の場合は、成功なので、データを返す。
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          if (data.containsKey('contents') && data['contents'] is List) {
            final contents = data['contents'] as List;
            logger.d('API Response👻: $contents');
            return contents
                .map((content) => ResponseModel.fromJson(content))
                .toList();
          } else {
            throw Exception('contents field is missing or null in data');
          }
        case 500:// 500の場合は、サーバーエラーなので、エラーを返す。
          throw MicroCMSApiStatus.serverError;
        default:// それ以外の場合は、ネットワークエラーなので、エラーを返す。
          throw MicroCMSApiStatus.networkError;
      }
    } catch (e) {
      // 例外が発生した場合は、Exceptionなので、エラーを返す。
      if (e is MicroCMSApiStatus) {
        throw Exception(e);
      } else {
        // network errorの場合は、enumのnetworkErrorを返す。
        throw MicroCMSApiStatus.networkError;
      }
    }
  }
}

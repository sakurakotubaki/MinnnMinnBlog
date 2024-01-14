import 'package:onion_architecture/domain/blog_state.dart';
import 'package:onion_architecture/infrastructure/micro_cms_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'micro_cms_state.g.dart';

/// [FutureProviderの代わりにAPIからデータを取得するのに使ってます]

@riverpod
class MicroCmsState extends _$MicroCmsState {
  /* AsyncNotifierはコンストラクターがないので、buildメソッドの中に、初期値か最初に実行する処理を書く.
  voidの時は、buildメソッドの中に処理は書かなくても良くて使うことができる。
  */
  @override
  FutureOr<List<ResponseModel>> build() {
    // ref.watch表示するデータを取得するメソッドを呼び出す。
    return getMicroCms();
  }
  // リポジトリーからAPIにHTTP GETするコードを呼び出す。voidじゃないので、throwする処理を書かないといけない。
  Future<List<ResponseModel>> getMicroCms() async {
    // 最初はローディング状態にする。
    state = const AsyncValue.loading();
    // AsyncValue.guardで、エラーが発生した場合は、エラーを返す。
    state = await AsyncValue.guard(() async {
      return await ref.read(microCMSApiImplProvider).getCategories();
    });
    // maybeWhenで、データがある場合は、データを返す。throwとして使ってる。これ書かないと、エラーが出る!
    return state.maybeWhen(
      data: (data) => data,
      orElse: () => throw Exception('Error: Failed to get data'),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onion_architecture/domain/blog_state.dart';
import 'package:onion_architecture/infrastructure/micro_cms_api.dart';

/// [FutureProviderでもいいけど、StateNotifierのAsyncValueを使ってみる。]

// MicroCmsNotifierどこで呼び出せるように、StateNotifierProviderを作成する。
final microCmsNotifierProvider =
    StateNotifierProvider<MicroCmsNotifier, AsyncValue<List<ResponseModel>>>(
        (ref) {
  return MicroCmsNotifier(ref);
});

class MicroCmsNotifier extends StateNotifier<AsyncValue<List<ResponseModel>>> {
  // コンストラクターにref.watchで表示するためのオブジェクトを渡す。
  MicroCmsNotifier(this.ref) : super(const AsyncValue.loading()) {
    // 最初に実行される処理として、getMicroCMC()を呼び出す。
    getMicroCMC();
  }
  // 古い書き方だと、Refを使う必要がある。riverpod2.0のAsyncNotifierでは使わない。
  final Ref ref;

  Future<List<ResponseModel>> getMicroCMC() async {
    // 最初はローディング状態にする。
    state = const AsyncValue.loading();
    // AsyncValue.guardで、エラーが発生した場合は、エラーを返す。
    state = await AsyncValue.guard(() async {
      return await ref.read(microCMSApiImplProvider).getCategories();
    });
    // maybeWhenで、データがある場合は、データを返す。
    return state.maybeWhen(
      data: (data) => data,
      orElse: () => throw Exception('Error: Failed to get data'),
    );
  }
}

## ユースケースに置くファイル
Flutterだと、Notifierを配置するみたい。ViewModelと同じことしてますね。リポジトリのコードを読んであげればOK!

## Riverpod1系の場合
StateNotifierのAsyncValueを使って、APIからデータを取得して、View側で、`ref.watch`して画面に取得したデータを描画することができます。
ロジックはレポジトリクラスから読んでるだけで、データの取得、エラー処理、ローディングの３しかやってないですね。

`AsyncValue.guard`を使うと、`try catch`を使わなくもよくなり簡潔に書ける。
[guard<T> static method](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncValue/guard.html)

```dart
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
```

## Riverpod2系の場合
AsyncNotifierを使うと、StateNotifierのAsyncValueより簡潔に書ける。`final Ref ref`を書かなくて良い!
Riverpod2系からは、こちらで書くのが推奨されてます!、FutureProviderと同じように、APIやFirebaseの特定のデータだけ取得するDocumentSnapShot、
１度だけ全部のデータを取得するQuerySnapShotを使うときに使うことができます。

[AsyncNotifier](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncNotifier-class.html)

```dart
import 'package:onion_architecture/domain/blog_state.dart';
import 'package:onion_architecture/infrastructure/micro_cms_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'micro_cms_state.g.dart';

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
```

# オニオン・アーキテクチャとは?

オニオンアーキテクチャは、ソフトウェアアーキテクチャの一種で、アプリケーションを複数のレイヤーに分割することで、各レイヤーの依存関係を制御し、コードの再利用性とテストの容易性を向上させることを目指しています。

Flutterでのオニオンアーキテクチャは以下のようになります：

1. ドメイン層（中心）：これはアプリケーションのビジネスロジックを含む層で、エンティティとビジネスルールが存在します。この層は他のどの層にも依存しません。

```dart
/// Flutterならモデルクラスを配置する
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'main.freezed.dart';
part 'main.g.dart';

@freezed
class モデル名 with _$モデル名 {
  const factory モデル名({
    required データ型 プロパティ名,
  }) = _モデル名;

  factory モデル名.fromJson(Map<String, Object?> json)
      => _$モデル名FromJson(json);
}
```

2. アプリケーション層：この層はドメイン層を使用して、ユースケースを実装します。この層はドメイン層に依存します。

```dart
/// FlutterだったらViewModelのNotifierを配置する
import 'package:microcms_api/core/logger.dart';
import 'package:microcms_api/model/blog_state.dart';
import 'package:microcms_api/repository/microcms_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'microcms_notifier.g.dart';

// ViewとModelの橋渡しをするViewModel
@riverpod
class MicroCmsNotifier extends _$MicroCmsNotifier {
  @override
  FutureOr<List<ResponseModel>> build() {
    return getCategories();
  }

  Future<List<ResponseModel>> getCategories() async {
    try {
      logger.d('AsyncNotifierを実行👻');
      return ref.read(microCmsApiProvider).getCategories();
    } catch (e) {
      logger.d('すべてのエラー: $e');
      throw Exception(e);
    }
  }
}
```

3. インフラストラクチャ層：この層はアプリケーションの永続性の詳細（データベース操作など）やネットワーク通信などを担当します。この層はアプリケーション層に依存します。

4. プレゼンテーション層：これはユーザーインターフェース（UI）を含む層で、ユーザーとの対話を管理します。この層はアプリケーション層に依存します。

このアーキテクチャの主な利点は、各層が独立しているため、変更やテストが容易であること、そして各層が特定の責任を持っているため、コードが整理されやすいことです。

coreについてですが、ここには、`logger`とかコンバーターのコードを置くそうです。

📁このアプリのディレクトリ構成:
```
lib
├── application
│   ├── README.md
│   ├── micro_cms_notifier.dart
│   ├── micro_cms_state.dart
│   ├── micro_cms_state.g.dart
│   └── usecase
├── core
│   └── logger.dart
├── domain
│   ├── README.md
│   ├── blog_state.dart
│   ├── blog_state.freezed.dart
│   └── blog_state.g.dart
├── infrastructure
│   ├── README.md
│   ├── micro_cms_api.dart
│   └── micro_cms_api.g.dart
├── main.dart
└── presentation
    ├── blog_page.dart
    └── detail_page.dart
```

参考になる動画のスクリーンショット:

<img src="./scree_shot/L.png" />

Riverpod + Freezedに合わせて設計してみた図:

<img src="./scree_shot/F.png" />

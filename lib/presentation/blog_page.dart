import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onion_architecture/application/micro_cms_state.dart';
import 'package:onion_architecture/presentation/detail_page.dart';

// MicroCMSのデータを表示するページ
class BlogPage extends ConsumerWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // APIからのデータは、`AsyncValue`のデータ型で渡されてくる
    final microCms = ref.watch(microCmsStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.env['HI'] ?? ''),// .envからテキストを取得
      ),
      body: microCms.when(
        data: (cms) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: ListView.builder(
              itemCount: cms.length,
              itemBuilder: (context, index) {
                final title = cms[index].title;
                return ListTile(
                  // Listをタップしたら、詳細ページに遷移する
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(responseModel: cms[index]),
                      ),
                    );
                  },
                  // アバター画像を表示
                  leading: cms[index].eyecatch != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(cms[index].eyecatch!.url)),
                        )
                      : null,
                  title: Text(title!),// ブログのタイトルを表示
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

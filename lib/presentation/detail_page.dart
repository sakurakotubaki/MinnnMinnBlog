import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onion_architecture/domain/blog_state.dart';

// ブログの詳細ページ
class DetailPage extends ConsumerWidget {
  const DetailPage({super.key, required this.responseModel});

  final ResponseModel responseModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ブログの詳細ページ'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                responseModel.title ?? 'No title',
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 20),
              Text(
                responseModel.content?.replaceAll(RegExp('<[^>]*>'), '') ??
                    'No content',
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:logger/logger.dart';
/// [print文は使わずに、logger.d('')などでログを出力する]
final logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // 表示するメソッド呼び出し数
      errorMethodCount: 8, // スタックトレースが提供される場合のメソッド呼び出し数
      lineLength: 120, // 出力の幅
      colors: true, // カラフルなログメッセージ
      printEmojis: true, // ログメッセージに絵文字を表示する
      printTime: false // 各ログ出力にタイムスタンプを含める
  ),
);

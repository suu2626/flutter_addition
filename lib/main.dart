import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChannelsを使用するためのインポート
import 'dart:math';

void main() {
  runApp(const MathApp());
}

class MathApp extends StatelessWidget {
  const MathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DifficultyPage(), // トップページの指定
    );
  }
}

// 難易度選択ページウィジェット
class DifficultyPage extends StatelessWidget {
  const DifficultyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('さんすうアプリ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'レベルをえらんでね',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 50), // テキストとボタン間のマージンを追加
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MathScreen(difficulty: 'かんたん'),
                  ),
                );
              },
              child: const Text('かんたん'),
            ),
            const SizedBox(height: 50), // ボタン間のマージン
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MathScreen(difficulty: 'ふつう'),
                  ),
                );
              },
              child: const Text('ふつう'),
            ),
            const SizedBox(height: 50), // ボタン間のマージン
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MathScreen(difficulty: 'むずかしい'),
                  ),
                );
              },
              child: const Text('むずかしい'),
            ),
          ],
        ),
      ),
    );
  }
}

// 足し算引き算問題を表示する画面ウィジェット
class MathScreen extends StatefulWidget {
  final String difficulty;
  const MathScreen({super.key, required this.difficulty});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

// 画面の状態を管理するステートクラス
class _MathScreenState extends State<MathScreen> {
  final Random _random = Random(); // 乱数生成
  late int _num1; // 最初の数
  late int _num2; // 2番目の数
  bool _isAddition = true; // 足し算かどうかを示すフラグ
  // ユーザー入力を管理するコントローラー
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // フォーカスを管理するノード
  String _message = ''; // 結果メッセージ

  @override
  void initState() {
    super.initState();
    _generateProblem(); // 初期状態で問題を生成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // 初期状態で入力欄にフォーカスを設定
      _showKeyboard(); // 数字キーボードを表示
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 新しい問題を生成するメソッド
  void _generateProblem() {
    setState(() {
      int maxRange;
      switch (widget.difficulty) {
        case 'かんたん':
          maxRange = 10;
          break;
        case 'ふつう':
          maxRange = 50;
          break;
        case 'むずかしい':
          maxRange = 100;
          break;
        default:
          maxRange = 10;
      }
      _num1 = _random.nextInt(maxRange); // ランダムな数を生成
      _num2 = _random.nextInt(maxRange) + 1; // ランダムな数を生成
      if (!_isAddition && _num1 < _num2) {
        // 引き算で左辺が右辺より小さい場合は入れ替える
        int temp = _num1;
        _num1 = _num2;
        _num2 = temp;
      }
      _controller.clear(); // ユーザー入力をクリア
      _message = ''; // メッセージをクリア
    });
    _focusNode.requestFocus(); // 新しい問題生成後に入力欄にフォーカスを設定
    _showKeyboard(); // 数字キーボードを表示
  }

// 数字キーボードを表示するメソッド
  void _showKeyboard() async {
    await Future.delayed(const Duration(milliseconds: 100));
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  // 答えをチェックするメソッド
  void _checkAnswer() {
    final int? userAnswer = int.tryParse(_controller.text); // 入力を整数に変換
    if (userAnswer == null) {
      // 入力が無効な場合
      setState(() {
        _message = 'すうじをいれてね！'; // エラーメッセージ
      });
      return;
    }

    final int correctAnswer =
        _isAddition ? _num1 + _num2 : _num1 - _num2; // 答えを計算
    if (userAnswer == correctAnswer) {
      // 答えが正しい場合
      setState(() {
        _message = 'せいかい！'; // 正解メッセージ
      });
    } else {
      // 答えが間違っている場合
      setState(() {
        _message = 'ざんねん！せいかいは $correctAnswer でした。'; // 不正解メッセージ
      });
    }
  }

  // 足し算ボタンが押されたときの処理
  void _setAddition() {
    setState(() {
      _isAddition = true;
      _generateProblem();
    });
  }

  // 引き算ボタンが押されたときの処理
  void _setSubtraction() {
    setState(() {
      _isAddition = false;
      _generateProblem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('さんすうアプリ'), // アプリケーションのタイトルを設定
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 画面の周囲にパディングを追加
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 縦方向に中央揃え
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _setAddition, // 足し算ボタンが押されたときに処理
                  child: const Text('たしざん'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _setSubtraction, // 引き算ボタンが押されたときに処理
                  child: const Text('ひきざん'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              _isAddition
                  ? '$_num1 + $_num2 = ?'
                  : '$_num1 - $_num2 = ?', // 現在の問題を表示
              style: const TextStyle(fontSize: 48), // 問題のテキストスタイル
            ),
            TextField(
              controller: _controller, // ユーザー入力コントローラを設定
              keyboardType: TextInputType.number, // 入力タイプを数字に設定
              focusNode: _focusNode, // フォーカスノードを設定
              decoration: const InputDecoration(
                  labelText: 'ここにこたえをいれてね！'), // プレースホルダーテキストを設定
              style: const TextStyle(fontSize: 40), // ユーザー入力テキストのフォントサイズを設定
            ),
            const SizedBox(height: 20), // スペース
            ElevatedButton(
              onPressed: _checkAnswer, // ボタンが押されたときに答えをチェック
              child: const Text('こたえあわせ'), // ボタンのテキスト
            ),
            const SizedBox(height: 20),
            Text(
              _message, // 結果メッセージを表示
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 20), // スペース
            ElevatedButton(
              onPressed: _generateProblem, // ボタンが押されたときに新しい問題を生成
              child: const Text('あたらしいもんだい'), // ボタンのテキスト
            ),
          ],
        ),
      ),
    );
  }
}

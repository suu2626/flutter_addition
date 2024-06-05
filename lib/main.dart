import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // SystemChannelsを使用するためのインポート
import 'dart:math';

void main() {
  runApp(const AdditionApp());
}

class AdditionApp extends StatelessWidget {
  const AdditionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MathScreen(), // メインの画面ウィジェットを指定
    );
  }
}

// 足し算引き算問題を表示する画面ウィジェット
class MathScreen extends StatefulWidget {
  const MathScreen({super.key});

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
      _num1 = _random.nextInt(10); // 0から9の間のランダムな数を生成
      _num2 = _random.nextInt(9) + 1; // 1から9の間のランダムな数を生成
      _controller.clear(); // ユーザー入力をクリア
      _message = ''; // メッセージをクリア
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // 新しい問題生成後に入力欄にフォーカスを設定
      _showKeyboard(); // 数字キーボードを表示
    });
  }

  // 数字キーボードを表示するメソッド
  void _showKeyboard() {
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
        title: const Text('Math App'), // アプリケーションのタイトルを設定
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

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const AdditionApp());
}

class AdditionApp extends StatelessWidget {
  const AdditionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addition App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdditionScreen(), // メインの画面ウィジェットを指定
    );
  }
}

// 足し算問題を表示する画面ウィジェット
class AdditionScreen extends StatefulWidget {
  const AdditionScreen({super.key});

  @override
  State<AdditionScreen> createState() => _AdditionScreenState();
}

// 画面の状態を管理するステートクラス
class _AdditionScreenState extends State<AdditionScreen> {
  final Random _random = Random(); // 乱数生成
  late int _num1; // 足し算の最初の数
  late int _num2; // 足し算の2番目の数
  // ユーザー入力を管理するコントローラー
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // フォーカスを管理するノード
  String _message = ''; // 結果メッセージ

  @override
  void initState() {
    super.initState();
    _generateProblem(); // 初期状態で足し算問題を生成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // 初期状態で入力欄にフォーカスを設定
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 新しい足し算問題を生成するメソッド
  void _generateProblem() {
    setState(() {
      _num1 = _random.nextInt(10); // 0から9の間のランダムな数を生成
      _num2 = _random.nextInt(9) + 1; // 1から9の間のランダムな数を生成
      _controller.clear(); // ユーザー入力をクリア
      _message = ''; // メッセージをクリア
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus(); // 新しい問題生成後に入力欄にフォーカスを設定
    });
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

    final int correctAnswer = _num1 + _num2; // 答えを計算
    if (userAnswer == correctAnswer) {
      // 答えが正しい場合
      setState(() {
        _message = 'せいかい！'; // 正解メッセージ
      });
      // 答えが間違っている場合
    } else {
      setState(() {
        _message = 'ざんねん！せいかいは $correctAnswer でした。'; // 不正解メッセージ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addition App'), // アプリケーションのタイトルを設定
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // 画面の周囲にパディングを追加
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 縦方向に中央揃え
          children: <Widget>[
            Text(
              '$_num1 + $_num2 = ?',
              style: const TextStyle(fontSize: 48), // 足し算問題を表示
            ),
            TextField(
              controller: _controller, // ユーザー入力コントローラを設定
              keyboardType: TextInputType.number, // 入力タイプを数字に設定
              focusNode: _focusNode, // フォーカスノードを設定
              decoration: const InputDecoration(
                  labelText: 'ここにこたえをいれてね！'), // プレースホルダーテキストを設定
              style: const TextStyle(fontSize: 40 // ユーザー入力テキストのフォントサイズを設定
                  // color: Colors.blue, // テキストの色
                  // fontFamily: 'Roboto', // フォントファミリ
                  // fontStyle: FontStyle.italic, // フォントスタイル
                  // fontWeight: FontWeight.bold, // フォントの太さ
                  ),
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

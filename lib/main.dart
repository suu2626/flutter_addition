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
      home: const AdditionScreen(),
    );
  }
}

class AdditionScreen extends StatefulWidget {
  const AdditionScreen({super.key});

  @override
  State<AdditionScreen> createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  final Random _random = Random();
  late int _num1;
  late int _num2;
  final TextEditingController _controller = TextEditingController();
  String _message = '';

  @override
  void initState() {
    super.initState();
    _generateProblem();
  }

  void _generateProblem() {
    setState(() {
      _num1 = _random.nextInt(10);
      _num2 = _random.nextInt(10);
      _controller.clear();
      _message = '';
    });
  }

  void _checkAnswer() {
    final int? userAnswer = int.tryParse(_controller.text);
    if (userAnswer == null) {
      setState(() {
        _message = 'すうじをいれてね！';
      });
      return;
    }

    final int correctAnswer = _num1 + _num2;
    if (userAnswer == correctAnswer) {
      setState(() {
        _message = 'せいかい！';
      });
    } else {
      setState(() {
        _message = 'ざんねん！せいかいは $correctAnswer でした。';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addition App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_num1 + $_num2 = ?',
              style: const TextStyle(fontSize: 24),
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'ここにこたえをいれてね！'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: const Text('こたえあわせ'),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateProblem,
              child: const Text('あたらしいもんだい'),
            ),
          ],
        ),
      ),
    );
  }
}

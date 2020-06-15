import 'package:flutter/material.dart';
import 'package:let_log/console.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _test();
    throw UnimplementedError();
  }

  void _test() {
    Console.log("1");
  }
}

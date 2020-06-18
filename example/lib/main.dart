import 'dart:async';

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
      // theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _test(null);
    Timer.periodic(const Duration(seconds: 5), _test);
    super.initState();
  }

  void _test(_) {
    // log
    Console.log("this is log");

    // debug
    Console.debug("this is debug", "this is debug message");

    // warn
    Console.warn("this is warn", "this is a warning message");

    // error
    Console.error("this is error", "this is a error message");

    // test error
    try {
      final aa = {};
      aa["aaa"]["sdd"] = 10;
    } catch (a, e) {
      Console.error(a, e);
    }

    // time test
    Console.time("timeTest");
    Console.endTime("timeTest");

    // log net work
    Console.net(
      "api/user/getUser",
      data: {"user": "yung", "pass": "xxxxxx"},
      head: null,
    );
    Console.endNet(
      "api/user/getUser",
      data: {
        "users": [
          {"id": 1, "name": "yung", "avatar": "xxx"},
          {"id": 2, "name": "yung2", "avatar": "xxx"}
        ]
      },
    );

    // log net work
    Console.net("ws/chat/getList", data: {"chanel": 1}, type: "Socket");
    Console.endNet(
      "ws/chat/getList",
      data: {
        "users": [
          {"id": 1, "name": "yung", "avatar": "xxx"},
          {"id": 2, "name": "yung2", "avatar": "xxx"}
        ]
      },
    );

    // clear log
    // Console.clear()

    // setting
    // Console.enabled = false;
    // Console.maxLimit = 10;
    // Console.showAsReverse = true;
    Console.setNames(
      log: "😄",
      debug: "🐛",
      warn: "❗",
      error: "❌",
      request: "⬆️",
      response: "⬇️",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Console();
  }
}

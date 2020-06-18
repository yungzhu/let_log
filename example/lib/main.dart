import 'dart:async';

import 'package:flutter/material.dart';
import 'package:let_log/logger.dart';

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
    Logger.log("this is log");

    // debug
    Logger.debug("this is debug", "this is debug message");

    // warn
    Logger.warn("this is warn", "this is a warning message");

    // error
    Logger.error("this is error", "this is a error message");

    // test error
    try {
      final aa = {};
      aa["aaa"]["sdd"] = 10;
    } catch (a, e) {
      Logger.error(a, e);
    }

    // time test
    Logger.time("timeTest");
    Logger.endTime("timeTest");

    // log net work
    Logger.net(
      "api/user/getUser",
      data: {"user": "yung", "pass": "xxxxxx"},
      head: null,
    );
    Logger.endNet(
      "api/user/getUser",
      data: {
        "users": [
          {"id": 1, "name": "yung", "avatar": "xxx"},
          {"id": 2, "name": "yung2", "avatar": "xxx"}
        ]
      },
    );

    // log net work
    Logger.net("ws/chat/getList", data: {"chanel": 1}, type: "Socket");
    Logger.endNet(
      "ws/chat/getList",
      data: {
        "users": [
          {"id": 1, "name": "yung", "avatar": "xxx"},
          {"id": 2, "name": "yung2", "avatar": "xxx"}
        ]
      },
    );

    // clear log
    // Logger.clear()

    // setting
    // Logger.enabled = false;
    // Logger.maxLimit = 10;
    // Logger.showAsReverse = true;
    // Logger.setNames(
    //   log: "😄",
    //   debug: "🐛",
    //   warn: "❗",
    //   error: "❌",
    //   request: "⬆️",
    //   response: "⬇️",
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Logger();
  }
}

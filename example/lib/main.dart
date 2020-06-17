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
  int _count = 0;
  @override
  void initState() {
    _test(null);
    Timer.periodic(const Duration(seconds: 5), _test);
    super.initState();
  }

  void _test(_) {
    try {
      var aa = {};
      aa["aaa"]["sdd"] = 10;
    } catch (a, e) {
      Console.error(a, e);
    }

    Console.error("this is error", "Console.error('this is a error message');");
    Console.warn("this is warn", "Console.warn('this is a error message');");
    Console.debug("this is debug", "Console.debug('this is a debug message');");
    Console.time("timeTest");
    Console.endTime("timeTest");
    Console.log("log ${_count++}");
    Console.net(
      "api/user/getUser$_count",
      data: {"user": "yung", "pass": "xxxxxx"},
    );
    Future.delayed(const Duration(seconds: 1), () {
      Console.endNet(
        "api/user/getUser$_count",
        data: {
          "schema": "http://json-schema.org/draft-04/schema#",
          "type": "object",
          "properties": {
            "arrArrStr": {
              "type": "array",
              "items": {
                "type": "array",
                "items": {"type": "string"}
              }
            },
            "arrArrObj": {
              "type": "array",
              "items": {
                "type": "array",
                "items": {"type": "object", "properties": {}}
              }
            },
            "objArr": {
              "type": "object",
              "properties": {
                "arr": {
                  "type": "array",
                  "items": {"type": "string"}
                }
              },
              "required": ["arr"]
            }
          },
          "required": ["arrArrObj", "objArr"]
        },
      );
    });
    // Console.clear();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Console.logWidget,
        Console.netWidget,
      ],
    );
  }
}

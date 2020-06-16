library console;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
part 'log_widget.dart';
part 'net_widget.dart';

class Console {
  static void log(Object value, [Object detail]) {
    _Log.add(_Type.log, value, detail);
  }

  static void debug(Object value, [Object detail]) {
    _Log.add(_Type.debug, value, detail);
  }

  static void warn(Object value, [Object detail]) {
    _Log.add(_Type.warn, value, detail);
  }

  static void error(Object value, [Object detail]) {
    _Log.add(_Type.error, value, detail);
  }

  static void time(Object value) {
    _Log.time(value);
  }

  static void endTime(Object value) {
    _Log.endTime(value);
  }

  static void clear() {
    _Log.clear();
  }

  static void net(
    String api, {
    String type = "Http",
    Object data,
    Object head,
  }) {
    _Net.request(api, type, data, head);
  }

  static void endNet(String api, {int status = 200, Object data}) {
    _Net.response(api, status, data);
  }

  static Widget get logWidget {
    return const LogWidget();
  }

  static Widget get netWidget {
    return const NetWidget();
  }
}

enum _Type { log, debug, warn, error }

class _Log {
  static final List<_Log> list = [];
  static final ValueNotifier<int> length = ValueNotifier(0);
  static final Map<Object, Object> _map = {};

  final _Type type;
  final String value;
  final String detail;
  const _Log({this.type, this.value, this.detail});

  static void add(_Type type, Object value, Object detail) {
    list.add(_Log(
      type: type,
      value: value?.toString(),
      detail: detail?.toString(),
    ));
    length.value++;
  }

  static void time(Object value) {
    _map[value] = DateTime.now();
  }

  static void endTime(Object value) {
    final data = _map[value];
    if (data != null) {
      _map.remove(value);
      final use = DateTime.now().difference(data).inMilliseconds;
      _Log.add(_Type.log, '$value: $use ms', null);
    }
  }

  static void clear() {
    list.clear();
    length.value = 0;
  }
}

class _Net extends ChangeNotifier {
  static final List<_Net> list = [];
  static final ValueNotifier<int> length = ValueNotifier(0);
  static final Map<String, _Net> _map = {};
  static const all = "all";
  static final List<String> types = [all];
  static final ValueNotifier<int> typeLength = ValueNotifier(1);

  final String api;
  final String type;
  final String req;
  final String head;
  final DateTime start;
  int status = 100;
  int spend = 0;
  String res;
  bool showDetail = false;

  _Net({
    this.api,
    this.type,
    this.req,
    this.head,
    this.start,
    this.res,
    this.spend,
  });

  int getReqSize() {
    if (req != null && req.isNotEmpty) {
      try {
        return utf8.encode(req).length;
      } catch (e) {
        // print(e);
      }
    }
    return 0;
  }

  int getResSize() {
    if (res != null && res.isNotEmpty) {
      try {
        return utf8.encode(res).length;
      } catch (e) {
        // print(e);
      }
    }
    return 0;
  }

  @override
  String toString() {
    final StringBuffer sb = StringBuffer();
    sb.writeln("[$status] $api");
    sb.writeln("start: $start");
    sb.writeln("spend: $spend ms");
    sb.writeln("Request: $req");
    sb.writeln("Response: $res");
    return sb.toString();
  }

  static void request(String api, String type, Object data, Object head) {
    final net = _Net(
      api: api,
      type: type,
      req: data?.toString(),
      head: head?.toString(),
      start: DateTime.now(),
    );
    list.add(net);
    _map[api] = net;
    if (type != null && type != "" && !types.contains(type)) {
      types.add(type);
      typeLength.value++;
    }
    length.value++;
  }

  static void response(String api, int status, Object data) {
    final net = _map[api];
    if (net != null) {
      _map.remove(net);
      net.spend = DateTime.now().difference(net.start).inMilliseconds;
      net.status = status;
      net.res = data?.toString();
      length.notifyListeners();
    } else {
      final net = _Net(api: api, res: data?.toString(), start: DateTime.now());
      list.add(net);
      length.value++;
    }
  }

  static void clear() {
    _map.clear();
    list.clear();
  }
}

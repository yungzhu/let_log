library console;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
part 'log_widget.dart';
part 'net_widget.dart';

class Console {
  static void log(Object message, [Object detail]) {
    _Log.add(_Type.log, message, detail);
  }

  static void debug(Object message, [Object detail]) {
    _Log.add(_Type.debug, message, detail);
  }

  static void warn(Object message, [Object detail]) {
    _Log.add(_Type.warn, message, detail);
  }

  static void error(Object message, [Object detail]) {
    _Log.add(_Type.error, message, detail);
  }

  static void time(Object key) {
    _Log.time(key);
  }

  static void endTime(Object key) {
    _Log.endTime(key);
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
  final String message;
  final String detail;
  final DateTime start;
  const _Log({this.type, this.message, this.detail, this.start});

  @override
  String toString() {
    final StringBuffer sb = StringBuffer();
    sb.writeln("Message: $message");
    sb.writeln("Time: $start");
    sb.writeln("Detail: ");
    sb.writeln(detail);
    return sb.toString();
  }

  static void add(_Type type, Object value, Object detail) {
    list.add(_Log(
      type: type,
      message: value?.toString(),
      detail: detail?.toString(),
      start: DateTime.now(),
    ));
    length.value++;
  }

  static void time(Object key) {
    _map[key] = DateTime.now();
  }

  static void endTime(Object key) {
    final data = _map[key];
    if (data != null) {
      _map.remove(key);
      final use = DateTime.now().difference(data).inMilliseconds;
      _Log.add(_Type.log, '$key: $use ms', null);
    }
  }

  static void clear() {
    list.clear();
    _map.clear();
    length.value = 0;
  }
}

class _Net extends ChangeNotifier {
  static const all = "All";
  static final List<_Net> list = [];
  static final ValueNotifier<int> length = ValueNotifier(0);
  static final Map<String, _Net> _map = {};
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
  int _reqSize = -1;
  int _resSize = -1;

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
    if (_reqSize > -1) return _reqSize;
    if (req != null && req.isNotEmpty) {
      try {
        return _reqSize = utf8.encode(req).length;
      } catch (e) {
        // print(e);
      }
    }
    return 0;
  }

  int getResSize() {
    if (_resSize > -1) return _resSize;
    if (res != null && res.isNotEmpty) {
      try {
        return _resSize = utf8.encode(res).length;
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
    sb.writeln("Head: $head");
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
    list.clear();
    _map.clear();
    length.value = 0;
  }
}

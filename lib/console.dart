library console;

import 'package:flutter/material.dart';
part 'log_widget.dart';

class Console {
  static void log(Object value, [Object detail]) {
    _Log.add(_Type.log, value, detail);
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

  static void net(String api, {Object data}) {
    _Net.request(api, data);
  }

  static void endNet(String api, {int status = 200, Object data}) {
    _Net.response(api, status, data);
  }

  static Widget get logWidget {
    return const LogWidget();
  }

  static Widget get netWidget {
    return const LogWidget();
  }
}

enum _Type { log, warn, error, time }

class _Log {
  static const List<_Log> list = [];
  static final ValueNotifier<int> length = ValueNotifier(0);
  static const Map<Object, Object> _map = {};

  final _Type type;
  final Object value;
  final Object detail;
  const _Log({this.type, this.value, this.detail});

  static void add(_Type type, Object value, Object detail) {
    list.add(_Log(type: type, value: value, detail: detail));
    length.value++;
  }

  static void time(Object value) {
    _map[value] = DateTime.now();
  }

  static void endTime(Object value) {
    final data = _map[value];
    if (data != null) {
      _map.remove(value);
      final use = DateTime.now().compareTo(data);
      _Log.add(_Type.time, '$value: $use ms', null);
    }
  }

  static void clear() {
    list.clear();
  }
}

class _Net {
  static const List<_Net> list = [];
  static final ValueNotifier<int> length = ValueNotifier(0);
  static const Map<String, _Net> _map = {};

  final String api;
  final Object req;
  final DateTime start;
  int status = 200;
  int useTime = 0;
  Object res;
  _Net({this.api, this.req, this.start, this.res, this.useTime});

  static void request(String api, Object data) {
    final net = _Net(api: api, req: data, start: DateTime.now());
    list.add(net);
    _map[api] = net;
    length.value++;
  }

  static void response(String api, int status, Object data) {
    final data = _map[api];
    if (data != null) {
      _map.remove(data);
      data.useTime = DateTime.now().compareTo(data.start);
      data.status = status;
      data.res = data;
      length.notifyListeners();
    } else {
      final net = _Net(api: api, res: data, start: DateTime.now());
      list.add(net);
      length.value++;
    }
  }

  static void clear() {
    _map.clear();
    list.clear();
  }
}

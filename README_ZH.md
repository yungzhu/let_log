# let_log

LetLog 是一个同时支持 IDE 和 App 内显示的 log 系统，并同时支持 log 和网络日志

文档语言: [English](README.md) | [中文简体](README_ZH.md)

## 开始

API 灵感来源于 web

**示例代码**

```
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
```

> 详细示例，请参考[这里](example/lib/main.dart)

**IDE 显示结果**

![Let Log](images/ide.png)

**在 App 内展示日志**

```
Widget build(BuildContext context) {
    return Console();
}
```

> 详细示例，请参考[这里](example/lib/main.dart)

**App 内日志界面**

![Let Log](images/log.png)

**App 内网络界面**

![Let Log](images/net.png)

**App 内搜索界面**

![Let Log](images/search.png)

**设置**

自定义分类名称

```
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
```

结果：

![Let Log](images/name.png)

## 功能

-   [x] 同时支持 IDE 打印和 App 内展示

-   [x] 同时支持日志，错误，时间统计，网络数据等信息输出

-   [x] 接口仿 web 的 console 类，提供 log，debug，warn，error，time，endTime，net，endNet 等接口

-   [x] 支持按照分类对日志内容进行过滤

-   [x] 支持按照关键词对日志内容进行过滤

-   [x] 支持 copy 日志内容

-   [x] 同时兼任 网络 Http 和 Socket

-   [x] 网络支持数据包大小，时长的统计

-   [x] 支持自定义日志分类符号，如果你喜欢，可以用 emoji 表情作为分类

-   [x] App 内多种颜色输出日志，让错误日志更明显

-   [x] 支持根据 App 自动切换黑白皮肤

-   [x] 支持一些自定义日志设置

## github 源码

> [https://github.com/yungzhu/let_log](https://github.com/yungzhu/let_log)

如果喜欢，帮忙给个 star

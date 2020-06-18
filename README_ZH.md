# let_log

LetLog 是一个同时支持 IDE 和 App 内显示的 log 系统，并同时支持 log 和网络日志

## Getting Started

API 灵感来源于 web

示例代码

```
// log
Console.log("this is log");

// debug
Console.debug("this is debug", "this is debug message");

// warn
Console.warn("this is warn", "this is a warning message");

// error
Console.error("this is error", "this is a error message");

// time test
Console.time("timeTest");
Console.endTime("timeTest");

// log net work
Console.net(
    "api/user/getUser$_count",
    data: {"user": "yung", "pass": "xxxxxx"},
);
Console.endNet(
    "api/user/getUser$_count",
    data: {
        users:[
        {id:1,name:"yung",avatar:"xxx"},
        {id:2,name:"yung2",avatar:"xxx"}
        ]
    },
);

// clear log
// Console.clear()

// disabled log
// Console.enabled = false;
```

同时支持 IDE 打印和 App 内展示
同时支持日志，错误，时间统计，网络数据等信息输出
接口仿 web 的 console 类，提供 log，debug，warn，error，time，endTime，net，endNet 等接口
支持按照分类对日志内容进行过滤
支持按照关键词对日志内容进行过滤
支持 copy 日志内容
同时兼任 网络 Http 和 Socket
网络支持数据包大小，时长的统计
支持自定义日志分类符号，如果你喜欢，可以用 emoji 表情作为分类
App 内多种颜色输出日志，让错误日志更明显
支持日志开关

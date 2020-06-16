part of console;

class LogWidget extends StatefulWidget {
  const LogWidget({Key key}) : super(key: key);

  @override
  _LogWidgetState createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logger"),
        elevation: 0,
        actions: const [
          FlatButton(
            onPressed: _Log.clear,
            child: Text("clear"),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTools(),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _Log.length,
              builder: (context, value, child) {
                final logs = _Log.list.where((test) {
                  return _selectTypes.contains(test.type);
                }).toList();
                final len = logs.length;
                return ListView.separated(
                  itemBuilder: (context, index) {
                    final item = logs[len - index - 1];
                    final color = _getColor(item.type, context);
                    return _buildItem(item, color);
                  },
                  itemCount: len,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 10,
                      thickness: 0.5,
                      color: Colors.grey,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(_Log item, Color color) {
    return InkWell(
      onTap: () {
        final ClipboardData data = ClipboardData(text: item.toString());
        Clipboard.setData(data);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return const Center(
              child: Material(
                color: Colors.transparent,
                child: Text(
                  "copy success!",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "[${_getTypeString(item.type)}] ${item.message}",
              style: TextStyle(fontSize: 16, color: color),
            ),
            if (item.detail != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  item.detail,
                  style: TextStyle(fontSize: 14, color: color.withAlpha(160)),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 20,
                ),
              )
          ],
        ),
      ),
    );
  }

  Color _getColor(_Type type, BuildContext context) {
    switch (type) {
      case _Type.debug:
        return Colors.blue;
      case _Type.warn:
        return Colors.yellow;
      case _Type.error:
        return Colors.red;
      default:
        return Theme.of(context).textTheme.bodyText1.color;
    }
  }

  final List<_Type> _selectTypes = [
    _Type.log,
    _Type.debug,
    _Type.warn,
    _Type.error
  ];

  Widget _buildTools() {
    final List<ChoiceChip> arr = [];
    _Type.values.forEach((f) {
      arr.add(
        ChoiceChip(
          label: Text(_getTypeString(f)),
          selected: _selectTypes.contains(f),
          onSelected: (value) {
            _selectTypes.contains(f)
                ? _selectTypes.remove(f)
                : _selectTypes.add(f);
            setState(() {});
          },
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 5, 0, 5),
      child: Row(
        children: [
          Expanded(
            child: Wrap(
              spacing: 10,
              children: arr,
            ),
          ),
          const IconButton(icon: Icon(Icons.search), onPressed: null),
        ],
      ),
    );
  }

  String _getTypeString(_Type type) {
    return type.toString().replaceFirst("_Type.", "");
  }
}

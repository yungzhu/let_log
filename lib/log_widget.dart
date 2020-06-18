part of let_log;

class LogWidget extends StatefulWidget {
  const LogWidget({Key key}) : super(key: key);

  @override
  _LogWidgetState createState() => _LogWidgetState();
}

class _LogWidgetState extends State<LogWidget> {
  bool _showSearch = false;
  String _keyword = "";
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: _keyword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildTools(),
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _Log.length,
            builder: (context, value, child) {
              List<_Log> logs = _Log.list;
              if (_selectTypes.length < 4 || _keyword.isNotEmpty) {
                logs = _Log.list.where((test) {
                  return _selectTypes.contains(test.type) &&
                      test.contains(_keyword);
                }).toList();
              }

              final len = logs.length;
              return ListView.separated(
                itemBuilder: (context, index) {
                  final item = Console.showAsReverse
                      ? logs[len - index - 1]
                      : logs[index];
                  final color = _getColor(item.type, context);
                  final messageStyle = TextStyle(fontSize: 16, color: color);
                  final detailStyle = TextStyle(fontSize: 14, color: color);
                  return _buildItem(item, messageStyle, detailStyle);
                },
                itemCount: len,
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 10,
                    thickness: 0.5,
                    color: Color(0xFFE0E0E0),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(_Log item, TextStyle messageStyle, TextStyle detailStyle) {
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
              "${item.typeName} ${item.message} (${item.start.hour}:${item.start.minute}:${item.start.second}:${item.start.millisecond})",
              style: messageStyle,
            ),
            if (item.detail != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  item.detail,
                  style: detailStyle,
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
        return const Color(0xFFF57F17);
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
          label: Text(_getTabName(f.index)),
          selectedColor: const Color(0xFFCBE2F6),
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
      child: AnimatedCrossFade(
        crossFadeState:
            _showSearch ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
        firstChild: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 10,
                children: arr,
              ),
            ),
            const IconButton(
              icon: Icon(Icons.clear),
              onPressed: _Log.clear,
            ),
            IconButton(
              icon: _keyword.isEmpty
                  ? const Icon(Icons.search)
                  : const Icon(Icons.filter_1),
              onPressed: () {
                _showSearch = true;
                setState(() {});
              },
            ),
          ],
        ),
        secondChild: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 36,
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(6),
                  ),
                  controller: _controller,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showSearch = false;
                _keyword = _controller.text;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

part of console;

class NetWidget extends StatefulWidget {
  const NetWidget({Key key}) : super(key: key);

  @override
  _NetWidgetState createState() => _NetWidgetState();
}

class _NetWidgetState extends State<NetWidget> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("NetWork"),
        elevation: 0,
        actions: [
          FlatButton(
            onPressed: _Net.clear,
            child: Text(
              "clear",
              style: TextStyle(color: Theme.of(context).secondaryHeaderColor),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ValueListenableBuilder<int>(
            valueListenable: _Net.typeLength,
            builder: (context, value, child) {
              return _buildTools();
            },
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: _Net.length,
              builder: (context, value, child) {
                List<_Net> logs = _Net.list;
                if (!_selectTypes.contains(_Net.all)) {
                  logs = _Net.list.where((test) {
                    return _selectTypes.contains(test.type) &&
                        test.contains(_keyword);
                  }).toList();
                } else if (_keyword.isNotEmpty) {
                  logs = _Net.list.where((test) {
                    return test.contains(_keyword);
                  }).toList();
                }

                final len = logs.length;
                return ListView.separated(
                  itemBuilder: (context, index) {
                    return _buildItem(logs[len - index - 1], context);
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
      ),
    );
  }

  Widget _buildItem(_Net item, context) {
    final color = _getColor(item.status);
    return InkWell(
      onTap: () {
        item.showDetail = !item.showDetail;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "[${item.type}] ${item.api}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (item.showDetail && item.head != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Head: ${item.head ?? ""}",
                        maxLines: 100,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  if (item.showDetail)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Request: ${item.req ?? ""}",
                        maxLines: 100,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  if (item.showDetail)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Response: ${item.res ?? ""}",
                        maxLines: 100,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            "${item.start.hour}:${item.start.minute}:${item.start.second}:${item.start.millisecond}",
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            "${item.spend ?? "0"} ms",
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                          ),
                        ),
                        Text(
                          "${item.getReqSize()}/${item.getResSize()}B",
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.visible,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            InkWell(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    item.status.toString(),
                    style: TextStyle(fontSize: 20, color: color),
                  ),
                  if (item.showDetail)
                    const Text(
                      "copy",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(int status) {
    if (status == 200 || status == 0) {
      return Colors.green;
    } else if (status < 200) {
      return Colors.blue;
    } else {
      return Colors.red;
    }
  }

  final List<String> _selectTypes = [_Net.all];

  Widget _buildTools() {
    final List<ChoiceChip> arr = [];
    _Net.types.forEach((f) {
      arr.add(
        ChoiceChip(
          label: Text(f),
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

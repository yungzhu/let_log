part of let_log;

class NetWidget extends StatefulWidget {
  const NetWidget({Key? key, this.onSavePressed}) : super(key: key);
  final Function(List<_Log> logs, List<_Net> netlogs)? onSavePressed;
  @override
  _NetWidgetState createState() => _NetWidgetState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<Function(List<_Log> logs, List<_Net> netlogs)?>.has(
            'onSavePressed', onSavePressed));
  }
}

class _NetWidgetState extends State<NetWidget> {
  bool _showSearch = false;
  String _keyword = "";
  TextEditingController? _textController;
  ScrollController? _scrollController;
  FocusNode? _focusNode;
  bool _goDown = true;

  @override
  void initState() {
    _textController = TextEditingController(text: _keyword);
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textController!.dispose();
    _scrollController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: const EdgeInsets.only(
                      bottom: kFloatingActionButtonMargin + 48),
                  itemBuilder: (context, index) {
                    final item = Logger.config.reverse
                        ? logs[len - index - 1]
                        : logs[index];
                    return _buildItem(item, context);
                  },
                  itemCount: len,
                  controller: _scrollController,
                  reverse: Logger.config.reverse,
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'save2',
            onPressed: () {
              if (widget.onSavePressed != null) {
                widget.onSavePressed!(_Log.list, _Net.list);
              }
            },
            label: const Text("Save to device"),
            icon: const Icon(Icons.save),
          ),
          FloatingActionButton(
            heroTag: 'down2',
            onPressed: () {
              if (_goDown) {
                _scrollController!.animateTo(
                  _scrollController!.position.maxScrollExtent * 2,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              } else {
                _scrollController!.animateTo(
                  0,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              }
              _goDown = !_goDown;
              setState(() {});
            },
            mini: true,
            child: Icon(
              _goDown ? Icons.arrow_downward : Icons.arrow_upward,
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
                  if (item.showDetail && item.headers != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "Headers: ${item.headers ?? ""}",
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
                          width: 120,
                          child: Text(
                            "${item.start!.hour}:${item.start!.minute}:${item.start!.second}:${item.start!.millisecond}",
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            "${item.spend} ms",
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
          label: Text(f, style: const TextStyle(fontSize: 14)),
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
                spacing: 5,
                children: arr,
              ),
            ),
            const IconButton(
              icon: Icon(Icons.clear),
              onPressed: _Net.clear,
            ),
            IconButton(
              icon: _keyword.isEmpty
                  ? const Icon(Icons.search)
                  : const Icon(Icons.filter_1),
              onPressed: () {
                _showSearch = true;
                setState(() {});
                _focusNode!.requestFocus();
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
                  controller: _textController,
                  focusNode: _focusNode,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _showSearch = false;
                _keyword = _textController!.text;
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

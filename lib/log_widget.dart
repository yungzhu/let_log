part of console;

class LogWidget extends StatelessWidget {
  const LogWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _Log.length,
      builder: (context, value, child) {
        return Container();
      },
    );
  }
}

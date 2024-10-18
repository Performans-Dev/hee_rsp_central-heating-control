import 'package:flutter/material.dart';

class ScreenSaverScreen extends StatefulWidget {
  final Widget child;
  final List<String> userlist;
  final Function(String) onUserSelect;
  const ScreenSaverScreen(
      {super.key,
      required this.child,
      required this.userlist,
      required this.onUserSelect});

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  bool _showUserList = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showUserList = !_showUserList;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            if (_showUserList)
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ...widget.userlist.map(
                    (e) => ListTile(
                      onTap: () {
                        widget.onUserSelect(e);
                      },
                      title: Text(
                        e,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

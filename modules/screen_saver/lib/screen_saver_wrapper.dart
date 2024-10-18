import 'package:flutter/material.dart';
import 'package:screen_saver/screen_saver_timer.dart';

class ScreenSaverWrapper extends StatefulWidget {
  final Widget child;
  final Widget content;

  final List<String> routes;


  final int timerDuration;
  final Function(String) onUserSelect;

  const ScreenSaverWrapper({
    super.key,
    required this.child,
    required this.content,
    required this.routes,
  
    required this.onUserSelect,
    this.timerDuration = 10,
  });

  @override
  State<ScreenSaverWrapper> createState() => _ScreenSaverWrapperState();
}

class _ScreenSaverWrapperState extends State<ScreenSaverWrapper> {
  final timerSingleton = ScreenSaverTimer();
  @override
  void initState() {
    super.initState();
    timerSingleton.init(
        content: widget.content,
      
        excludedRoutes: widget.routes,
        timerDuration: widget.timerDuration,
        onUserSelect: widget.onUserSelect);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        timerSingleton.startTimer();
      },
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}

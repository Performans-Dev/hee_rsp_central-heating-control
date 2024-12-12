import 'package:flutter/material.dart';
import 'package:screen_saver/screen_saver_definition.dart';
import 'package:screen_saver/screen_saver_timer.dart';

class ScreenSaverWrapper extends StatefulWidget {
  final Widget child;
  final List<String> excludedRoutes;
  final int timerDuration;
  final ScreenSaverDefinition definition;
  final bool allowNoUser;
  const ScreenSaverWrapper({
    super.key,
    required this.child,
    required this.excludedRoutes,
    required this.definition,
    this.timerDuration = 10,
    this.allowNoUser = false,
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
      definition: widget.definition,
      excludedRoutes: widget.excludedRoutes,
      timerDuration: widget.timerDuration,
      allowNoUser: widget.allowNoUser,
    );
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

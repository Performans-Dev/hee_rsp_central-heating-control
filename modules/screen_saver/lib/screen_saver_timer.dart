import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_saver/screen_saver_screen.dart';


class ScreenSaverTimer {
  static final ScreenSaverTimer _instance = ScreenSaverTimer._internal();
  Timer? _timer;
  bool isActive = false;
  late Widget _content;
  late List<String> _excludedRoutes;
  late dynamic _userlist;

  Widget get content => _content;
  List<String> get excludedRoutes => _excludedRoutes;
  dynamic get userlist => _userlist;
  int _timerDuration = 10;
  late Function(String) _onUserSelect;

  factory ScreenSaverTimer() {
    return _instance;
  }

  ScreenSaverTimer._internal();

  void init({
    required Widget content,
    dynamic userlist,
    required List<String> excludedRoutes,
    required int timerDuration,
    required Function(String) onUserSelect,
  }) {
    _content = content;
    _userlist = userlist;
    _excludedRoutes = excludedRoutes;
    _timerDuration = timerDuration;
    _onUserSelect = onUserSelect;
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer(Duration(seconds: _timerDuration), _activateScreensaver);
  }

  void _activateScreensaver() {
    if (isActive) return;
    isActive = true;

    if (excludedRoutes.contains(Get.currentRoute)) {
      startTimer();
    } else {
      Get.to(() => ScreenSaverScreen(
            userlist: userlist,
            onUserSelect: _onUserSelect,
            child: content,
          ));
    }
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}

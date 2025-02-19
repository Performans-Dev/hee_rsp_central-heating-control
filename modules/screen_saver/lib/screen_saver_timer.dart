import 'dart:async';

import 'package:get/get.dart';
import 'package:screen_saver/screen_saver_definition.dart';
import 'package:screen_saver/screen_saver_screen.dart';

class ScreenSaverTimer {
  static final ScreenSaverTimer _instance = ScreenSaverTimer._internal();
  Timer? _timer;
  bool isActive = false;
  bool _allowNoUser = false;
  bool get allowNoUser => _allowNoUser;

  late List<String> _excludedRoutes;

  List<String> get excludedRoutes => _excludedRoutes;

  int _timerDuration = 10;
  late ScreenSaverDefinition _definition;

  factory ScreenSaverTimer() {
    return _instance;
  }

  ScreenSaverTimer._internal();

  void init({
    dynamic userlist,
    required List<String> excludedRoutes,
    required int timerDuration,
    required ScreenSaverDefinition definition,
    required bool allowNoUser,
  }) {
    _excludedRoutes = excludedRoutes;
    _timerDuration = timerDuration;
    _definition = definition;
    _allowNoUser = allowNoUser;

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
            definition: _definition,
          ));
    }
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}

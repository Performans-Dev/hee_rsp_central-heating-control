import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:screen_saver/screen_saver_timer.dart';

class ScreenSaverObserver extends NavigatorObserver {
  final List<String> autoLockExcludedRoutes;
  ScreenSaverObserver({required this.autoLockExcludedRoutes});
  @override
  void didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didPush(
      route,
      previousRoute,
    );
    log('didPush: ${route.settings.name}');
    final timerSingleton = ScreenSaverTimer();
    timerSingleton.isActive = false;
    var routeName = (route.settings.name ?? "").contains("?")
        ? route.settings.name?.split("?")[0]
        : route.settings.name;
    if (autoLockExcludedRoutes.contains(routeName)) {
      timerSingleton.cancelTimer();
      log('Screensaver is disabled for: $routeName');
    } else {
      timerSingleton.startTimer();
      log('Screensaver is enabled for: $routeName');
    }
  }
}

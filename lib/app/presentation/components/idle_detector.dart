import 'dart:async';

import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdleDetector extends StatefulWidget {
  final GetMaterialApp child;
  final int timeoutSeconds;
  final List<String> excludedRoutes;

  const IdleDetector({
    super.key,
    required this.child,
    this.timeoutSeconds = 60,
    required this.excludedRoutes,
  });

  @override
  State<IdleDetector> createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == widget.timeoutSeconds) {
        if (!_isExcludedRoute()) {
          _lockScreen();
        } else {
          _resetTimer();
        }
      }
    });
  }

  void _resetTimer() {
    Buzz.mini();
    _timer?.cancel();
    _startTimer();
  }

  void _lockScreen() {
    Buzz.lock();
    Get.toNamed(Routes.lockScreen);
  }

  bool _isExcludedRoute() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return widget.excludedRoutes.contains(currentRoute);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _resetTimer,
      onLongPress: _resetTimer,
      onHorizontalDragUpdate: (details) {
        // Handle horizontal swipe
        if (details.delta.dx.abs() > 100) {
          _resetTimer();
        }
      },
      onVerticalDragUpdate: (details) {
        // Handle vertical swipe
        if (details.delta.dy.abs() > 100) {
          _resetTimer();
        }
      },
      // Add other touch event listeners as needed
      child: widget.child,
    );
  }
}

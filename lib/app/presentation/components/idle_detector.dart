import 'dart:async';

import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IdleDetector extends StatefulWidget {
  final Widget child;
  final List<String> excludedRoutes;

  const IdleDetector({
    super.key,
    required this.child,
    required this.excludedRoutes,
  });

  @override
  State<IdleDetector> createState() => _IdleDetectorState();
}

class _IdleDetectorState extends State<IdleDetector> {
  Timer? _idleTimer;
  bool _isScreensaverActive = false;

  @override
  void initState() {
    super.initState();
    _startIdleTimer();
  }

  void _startIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = Timer(const Duration(minutes: 5), _showScreensaver);
  }

  void _showScreensaver() {
    if (!_isExcludedRoute()) {
      setState(() {
        _isScreensaverActive = true;
      });
    }
  }

  void _resetIdleTimer() {
    if (!_isExcludedRoute()) {
      _startIdleTimer();
      if (_isScreensaverActive) {
        setState(() {
          _isScreensaverActive = false;
        });
        // Get.offAllNamed(Routes.screenSaver); // Navigate to login screen
      }
    }
  }

  bool _isExcludedRoute() {
    return widget.excludedRoutes.contains(Get.currentRoute);
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: _resetIdleTimer,
        onPanUpdate: (details) => _resetIdleTimer(),
        child: Stack(
          children: [
            widget.child,
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: _isScreensaverActive
                  ? GestureDetector(
                      onTap: _resetIdleTimer, // Handle taps on the screensaver
                      child: AnimatedOpacity(
                        opacity: _isScreensaverActive ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: const Stack(
                          fit: StackFit.expand,
                          children: [
                            Placeholder(),
                            Center(
                              child: DateTextWidget(large: true),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

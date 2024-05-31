import 'dart:async';

import 'package:central_heating_control/app/data/routes/routes.dart';
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
    _idleTimer = Timer(Duration(minutes: 5), _showScreensaver);
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
              duration: Duration(seconds: 1),
              child: _isScreensaverActive
                  ? GestureDetector(
                      onTap: _resetIdleTimer, // Handle taps on the screensaver
                      child: AnimatedOpacity(
                        opacity: _isScreensaverActive ? 1.0 : 0.0,
                        duration: Duration(seconds: 1),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              'https://c4.wallpaperflare.com/wallpaper/849/720/847/two-white-5-petaled-flowers-wallpaper-preview.jpg',
                              fit: BoxFit.cover,
                              width: Get.width,
                              height: Get.height,
                            ),
                            const Center(
                              child: DateTextWidget(large: true),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
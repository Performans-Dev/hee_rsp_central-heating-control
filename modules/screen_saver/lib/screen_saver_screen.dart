import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:screen_saver/screen_saver_definition.dart';
import 'package:screen_saver/screen_saver_timer.dart';

class ScreenSaverScreen extends StatefulWidget {
  final ScreenSaverDefinition definition;

  const ScreenSaverScreen({
    super.key,
    required this.definition,
  });

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  bool _showUserList = false;
  Timer? timeChangeTimer;
  AlignmentGeometry timeAlignment = Alignment.center;
  double x = 0;
  double y = 0;

  @override
  void initState() {
    super.initState();
    startTimeChangeTimer();
  }

  @override
  void dispose() {
    timeChangeTimer?.cancel();
    super.dispose();
  }

  void startTimeChangeTimer() {
    timeChangeTimer = Timer.periodic(const Duration(seconds: 13), (timer) {
      setState(() {
        timeAlignment = getRandomAlignment();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showUserList = !_showUserList;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            widget.definition.content,
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 0, top: 20),
                child: Opacity(
                  opacity: 0.4,
                  child: widget.definition.logo,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.topRight,
              child: Opacity(
                opacity: 0.4,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Central Controller ",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () => onTap(context),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                ),
              ),
            ),
            InkWell(
              onTap: () => onTap(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: timeAlignment,
                  child: Opacity(
                    opacity: 0.83,
                    child: widget.definition.date,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onTap(BuildContext context) async {
    Future.delayed(Duration.zero, () {
      if (!context.mounted) {
        return;
      }
      ScreenSaverTimer sst = ScreenSaverTimer();
      if (sst.allowNoUser) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
            barrierColor: Colors.black.withValues(alpha: 0.3),
            barrierDismissible: true,
            opaque: false,
            pageBuilder: (_, __, ___) => widget.definition.target,
          ),
        );
      }
    });
  }

  AlignmentGeometry getRandomAlignment() {
    final random = Random();
    double x = (random.nextDouble() * 1.4) - 0.7;
    double y = (random.nextDouble() * 1.4) - 0.7;
    return Alignment(x, y);
  }
}

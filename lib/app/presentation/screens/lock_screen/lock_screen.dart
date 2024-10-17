import 'dart:async';
import 'dart:math';

import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/core/utils/nav.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool showUserList = true;
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

  AlignmentGeometry getRandomAlignment() {
    final random = Random();
    x = (random.nextDouble() * 1.4) - 0.7;
    y = (random.nextDouble() * 1.4) - 0.7;
    return Alignment(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return Scaffold(
          body: Container(
            color: Colors.black,
            child: Stack(
              children: [
                const WallpaperWidget(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 0, top: 20),
                    child: const Opacity(
                      opacity: 0.4,
                      child: LogoWidget(
                        themeMode: ThemeMode.dark,
                        height: 30,
                      ),
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
                  onTap: () {
                    Nav.toUserList(context: context);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: timeAlignment,
                    child: const Opacity(
                      opacity: 0.83,
                      child: DateTextWidget(large: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

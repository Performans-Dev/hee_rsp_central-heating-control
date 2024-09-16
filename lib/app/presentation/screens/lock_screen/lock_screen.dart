import 'dart:async';
import 'dart:math';

import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
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
  int currentImageIndex = 0;
  Timer? imageChangeTimer;
  Timer? timeChangeTimer;
  AlignmentGeometry timeAlignment = Alignment.center;
  double x = 0;
  double y = 0;
  final List<String> imageUrls = List.generate(
      12,
      (e) =>
          'https://static.api2.run/pi/wallpaper/wp${('0${e + 1}'.right(2))}.jpg');

  @override
  void initState() {
    super.initState();
    startImageChangeTimer();
    startTimeChangeTimer();
  }

  @override
  void dispose() {
    imageChangeTimer?.cancel();
    timeChangeTimer?.cancel();
    super.dispose();
  }

  void startImageChangeTimer() {
    imageChangeTimer = Timer.periodic(const Duration(seconds: 31), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
      });
    });
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
                WallpaperWidget(),
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
                  onTap: () => setState(() {
                    showUserList = !showUserList;
                  }),
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
                Align(
                  alignment: Alignment.bottomLeft,
                  child: AnimatedContainer(
                    width: 300,
                    height:
                        showUserList ? (64 * app.appUserList.length) + 32 : 0,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20)),
                      color: Theme.of(context).focusColor.withOpacity(0.3),
                    ),
                    padding: const EdgeInsets.all(16),
                    duration: const Duration(milliseconds: 300),
                    child: showUserList
                        ? ListView.builder(
                            shrinkWrap: false,
                            itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                child: Text(app.appUserList[index].username
                                    .getInitials()),
                              ),
                              title: Text(
                                app.appUserList[index].username,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.83),
                                    ),
                              ),
                              onTap: () async {
                                final pin = await DialogUtils.pinDialog(
                                  context: context,
                                  username: app.appUserList[index].username,
                                );
                                if (pin != null && pin.length == 6) {
                                  final loginResult = await app.loginUser(
                                      username: app.appUserList[index].username,
                                      pin: pin);
                                  if (loginResult) {
                                    NavController.toHome();
                                  } else {
                                    const snackBar = SnackBar(
                                      content: Text('Incorrect PIN code.'),
                                      duration: Duration(seconds: 2),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                } else {
                                  const snackBar = SnackBar(
                                    content: Text(
                                        'PIN code required, Tap your "Name" and enter your PIN code.'),
                                    duration: Duration(seconds: 2),
                                  );
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                            ),
                            itemCount: app.appUserList.length,
                          )
                        : null,
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

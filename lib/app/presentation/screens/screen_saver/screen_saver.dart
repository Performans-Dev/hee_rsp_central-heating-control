import 'dart:async';

import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSaverScreen extends StatefulWidget {
  const ScreenSaverScreen({super.key});

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  bool showUserList = true;
  int currentImageIndex = 0;
  Timer? imageChangeTimer;
  AlignmentGeometry timeAlignment = Alignment.center;

  final List<String> imageUrls = [
    'https://c4.wallpaperflare.com/wallpaper/849/720/847/two-white-5-petaled-flowers-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/142/751/831/landscape-anime-digital-art-fantasy-art-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/800/831/598/digital-art-neon-mountains-lake-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/135/692/935/astronaut-space-black-background-artwork-hd-wallpaper-preview.jpg',
    'https://c4.wallpaperflare.com/wallpaper/767/612/930/nature-landscape-trees-digital-art-wallpaper-preview.jpg',
  ];

  @override
  void initState() {
    super.initState();
    startImageChangeTimer();
  }

  @override
  void dispose() {
    imageChangeTimer?.cancel();
    super.dispose();
  }

  void startImageChangeTimer() {
    imageChangeTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % imageUrls.length;
        timeAlignment = getRandomAlignment();
      });
    });
  }

  AlignmentGeometry getRandomAlignment() {
    final alignments = [
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomCenter,
      Alignment.bottomRight,
    ];
    alignments.shuffle();
    return alignments.first;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.56,
                child: Image.network(
                  imageUrls[currentImageIndex],
                  fit: BoxFit.cover,
                  width: Get.width,
                  height: Get.height,
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
                  height: showUserList ? (64 * app.userList.length) + 32 : 0,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(20)),
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.all(16),
                  duration: const Duration(milliseconds: 300),
                  child: showUserList
                      ? ListView.builder(
                          shrinkWrap: false,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                  app.userList[index].username.getInitials()),
                            ),
                            title: Text(
                              app.userList[index].username,
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
                                username: app.userList[index].username,
                              );
                              if (pin != null && pin.length == 6) {
                                final loginResult = await app.loginUser(
                                    username: app.userList[index].username,
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
                          itemCount: app.userList.length,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
/* import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenSaverScreen extends StatefulWidget {
  const ScreenSaverScreen({super.key});

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  bool showUserList = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.56,
                child: Image.network(
                  'https://c4.wallpaperflare.com/wallpaper/849/720/847/two-white-5-petaled-flowers-wallpaper-preview.jpg',
                  fit: BoxFit.cover,
                  width: Get.width,
                  height: Get.height,
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
              const Center(
                child: Opacity(
                  opacity: 0.83,
                  child: DateTextWidget(large: true),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedContainer(
                  width: 300,
                  height: showUserList ? (64 * app.userList.length) + 32 : 0,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(20)),
                    color: Theme.of(context).focusColor.withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.all(16),
                  duration: const Duration(milliseconds: 300),
                  child: showUserList
                      ? ListView.builder(
                          shrinkWrap: false,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                  app.userList[index].username.getInitials()),
                            ),
                            title: Text(
                              app.userList[index].username,
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
                                username: app.userList[index].username,
                              );
                              if (pin != null && pin.length == 6) {
                                final loginResult = await app.loginUser(
                                    username: app.userList[index].username,
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
                          itemCount: app.userList.length,
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
} */
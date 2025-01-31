import 'dart:io';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesLockScreen extends StatefulWidget {
  const SettingsPreferencesLockScreen({super.key});

  @override
  State<SettingsPreferencesLockScreen> createState() =>
      _SettingsPreferencesLockScreenState();
}

class _SettingsPreferencesLockScreenState
    extends State<SettingsPreferencesLockScreen> {
  late int selectedIdleTimeout;
  late int selectedSlideTime;
  late ScreenSaverType screenSaverType;
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    selectedIdleTimeout = Box.getInt(
      key: Keys.idleTimerInSeconds,
      defaultVal: 60,
    );
    selectedSlideTime = Box.getInt(
      key: Keys.slideShowTimer,
      defaultVal: 10,
    );
    screenSaverType = ScreenSaverType.values[Box.getInt(
      key: Keys.screenSaverType,
      defaultVal: 2,
    )];

    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Lock Screen',
      selectedIndex: 3,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: PiScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LabelWidget(
                        text: "Lock Screen Duration",
                      ),
                      Text(CommonUtils.secondsToHumanReadable(
                          selectedIdleTimeout)),
                    ],
                  ),
                  Slider(
                    value: selectedIdleTimeout.toDouble(),
                    onChanged: (value) {
                      setState(() => selectedIdleTimeout = value.toInt());
                    },
                    min: 15.0,
                    max: 300.0,
                    divisions: 57,
                  ),
                  const Divider(),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LabelWidget(text: 'Screen Saver'),
                    ],
                  ),
                  ...ScreenSaverType.values.map((e) => RadioListTile(
                        value: e,
                        selected: e == screenSaverType,
                        groupValue: screenSaverType,
                        onChanged: (v) async {
                          setState(() {
                            screenSaverType = e;
                          });
                          try {
                            if (screenSaverType == ScreenSaverType.fun) {
                              final dir = Directory('/home/pi/Pictures/fun');
                              if (!dir.existsSync()) {
                                dir.createSync();
                              }
                              final funImages = dir.listSync();
                              if (funImages.isEmpty) {
                                for (int i = 0; i <= 8; i++) {
                                  await Process.run(
                                      'wget',
                                      [
                                        'https://releases.api2.run/heethings/cc/images/ilm0$i.gif',
                                      ],
                                      workingDirectory:
                                          '/home/pi/Pictures/fun');
                                }
                              }
                            }
                          } on Exception catch (_) {
                            // ignore network error
                          }
                        },
                        title: Text(e.name.camelCaseToHumanReadable()),
                        shape: RoundedRectangleBorder(
                            borderRadius: UiDimens.formRadius),
                      )),
                  screenSaverType == ScreenSaverType.slidePictures
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelWidget(text: 'Slider Time'),
                                Text(CommonUtils.secondsToHumanReadable(
                                    selectedSlideTime)),
                              ],
                            ),
                            Slider(
                              value: selectedSlideTime.toDouble(),
                              onChanged: (value) {
                                setState(
                                    () => selectedSlideTime = value.toInt());
                              },
                              min: 10,
                              max: 30.0,
                              divisions: 20,
                            ),
                          ],
                        )
                      : screenSaverType == ScreenSaverType.staticPicture
                          ? SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (c, i) => Container(
                                  margin: const EdgeInsets.all(2),
                                  width: 120,
                                  height: 96,
                                  child: Image.file(
                                    images[i],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                itemCount: images.length,
                              ),
                            )
                          : Container(),
                ],
              ),
            ),
          ),
          actionButton,
        ],
      ),
    );
  }

  Widget get actionButton => Container(
        // color: Theme.of(context).focusColor,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel")),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                await Box.setInt(
                    key: Keys.idleTimerInSeconds, value: selectedIdleTimeout);
                await Box.setInt(
                    key: Keys.screenSaverType, value: screenSaverType.index);
                // final AppController app = Get.find();
                /* TODO:
                 app.setIdleTime(selectedIdleTimeout);
                app.setSlideTime(selectedSlideTime); */
                Get.back();
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      );

  Future<void> _loadImages() async {
    final directory = Directory('/home/pi/Pictures');
    // Directory(path.join(
    //     (await getApplicationDocumentsDirectory()).path, 'Pictures/cc'));
    if (directory.existsSync()) {
      final imageFiles = directory.listSync().where((file) =>
          file.path.endsWith('.jpg') ||
          file.path.endsWith('.jpeg') ||
          file.path.endsWith('.png'));
      setState(() {
        images = imageFiles.map((file) => File(file.path)).toList();
      });
    }
  }
}

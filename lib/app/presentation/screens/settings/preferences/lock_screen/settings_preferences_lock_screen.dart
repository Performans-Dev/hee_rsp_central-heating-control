import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
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
                      const Text('Kilit Ekranı Süresi'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Screen Saver'),
                    ],
                  ),
                  ...ScreenSaverType.values.map((e) => RadioListTile(
                        value: e,
                        selected: e == screenSaverType,
                        groupValue: screenSaverType,
                        onChanged: (v) {
                          setState(() {
                            screenSaverType = e;
                          });
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
                                const Text('Slider Süresi'),
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
                final AppController app = Get.find();
                app.setIdleTime(selectedIdleTimeout);
                app.setSlideTime(selectedSlideTime);
                Get.back();
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      );
}

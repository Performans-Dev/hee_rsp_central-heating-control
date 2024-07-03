import 'dart:math' as math;

import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupThemeScreen extends StatefulWidget {
  const SetupThemeScreen({super.key});

  @override
  State<SetupThemeScreen> createState() => _SetupThemeScreenState();
}

class _SetupThemeScreenState extends State<SetupThemeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return SetupScaffold(
        label: 'Select Theme',
        nextCallback: () {
          Get.toNamed(Routes.setupLanguage);
        },
        progressValue: 1 / 20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Pick a theme'.tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: app.themeList.length,
                    itemBuilder: (context, index) => RadioListTile(
                      value: index,
                      groupValue: selectedIndex,
                      onChanged: (value) {
                        setState(() {
                          selectedIndex = index;
                        });

                        app.setSelectedTheme(app.themeList[index]);
                        RestartWidget.restartApp(context);
                      },
                      title:
                          Text(app.themeList[index].camelCaseToHumanReadable()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: UiDimens.formRadius,
                    ),
                    elevation: 12,
                    child: ClipRRect(
                      borderRadius: UiDimens.formRadius,
                      child: SizedBox(
                        height: 160,
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Transform.rotate(
                                angle: -math.pi / 8.0,
                                child: Icon(
                                  Icons.sensors,
                                  color: app.isDarkMode
                                      ? Theme.of(context).highlightColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8),
                                  size: 240,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: const Text('Sample')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            CheckboxListTile(
              title: Text(
                'Dark Mode'.tr,
              ),
              value: app.isDarkMode,
              onChanged: (v) {
                app.toggleDarkMode();
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      );
    });
  }
}

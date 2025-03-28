import 'dart:math' as math;

import 'package:central_heating_control/app/app.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceThemeScreen extends StatefulWidget {
  const SetupSequenceThemeScreen({super.key});

  @override
  State<SetupSequenceThemeScreen> createState() =>
      _SetupSequenceThemeScreenState();
}

class _SetupSequenceThemeScreenState extends State<SetupSequenceThemeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupLayout(
              title: 'Select Theme'.tr,
              nextCallback: () async {
                Buzz.feedback();
                // await Box.setBool(key: Keys.didThemeSelected, value: true);
                app.setPreferencesDefinition(app.preferencesDefinition.copyWith(
                  themeIndex: selectedIndex,
                  didSelectedTheme: true,
                ));

                sc.refreshSetupSequenceList();
                NavController.toHome();
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  LabelWidget(
                    text: 'Pick a theme'.tr,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: StaticProvider.getThemeList.length,
                          itemBuilder: (context, index) => RadioListTile(
                            value: index,
                            groupValue: selectedIndex,
                            onChanged: (value) {
                              Buzz.feedback();
                              setState(() {
                                selectedIndex = index;
                              });
                              app.setPreferencesDefinition(
                                  app.preferencesDefinition.copyWith(
                                themeIndex: index,
                                didSelectedTheme: true,
                              ));

                              RestartWidget.restartApp(context);
                            },
                            title: Text(
                              StaticProvider.getThemeList[index]
                                  .camelCaseToHumanReadable()
                                  .tr,
                            ),
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
                                        color: app.preferencesDefinition.isDark
                                            ? Theme.of(context).highlightColor
                                            : Theme.of(context)
                                                .primaryColor
                                                .withValues(alpha: 0.8),
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
                                            child: Text('Sample'.tr)),
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
                  ToggleButtons(
                    isSelected: ThemeMode.values
                        .map(
                          (e) =>
                              e ==
                              ThemeMode.values[
                                  app.preferencesDefinition.themeModeIndex],
                        )
                        .toList(),
                    onPressed: (index) async {
                      app.setPreferencesDefinition(
                          app.preferencesDefinition.copyWith(
                        themeModeIndex: index,
                        didSelectedTheme: true,
                      ));

                      if (context.mounted) {
                        RestartWidget.restartApp(context);
                      }
                    },
                    borderRadius: UiDimens.formRadius,
                    constraints:
                        const BoxConstraints(minWidth: 120, minHeight: 40),
                    children: ThemeMode.values
                        .map((e) => Text(
                              e.name.camelCaseToHumanReadable().tr,
                            ))
                        .toList(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

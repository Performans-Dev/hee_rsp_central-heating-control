import 'dart:math' as math;

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/common/datetime_display.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesDateTimeFormatScreen extends StatefulWidget {
  const PreferencesDateTimeFormatScreen({super.key});

  @override
  State<PreferencesDateTimeFormatScreen> createState() =>
      _PreferencesDateTimeFormatScreenState();
}

class _PreferencesDateTimeFormatScreenState
    extends State<PreferencesDateTimeFormatScreen> {
  final AppController appController = Get.find();
  final dateFormatList = StaticProvider.getDateFormatList;
  final timeFormatList = StaticProvider.getTimeFormatList;
  late String dateFormat;
  late String timeFormat;
  late ScrollController dateScrollController;
  late ScrollController timeScrollController;

  @override
  void initState() {
    super.initState();
    dateFormat = appController.preferences.dateFormat;
    timeFormat = appController.preferences.timeFormat;
    dateScrollController = ScrollController();
    timeScrollController = ScrollController();
    Future.delayed(const Duration(milliseconds: 100), _scrollToInitial);
  }

  void _scrollToInitial() {
    final index = dateFormatList.indexWhere((element) => element == dateFormat);
    dateScrollController.animateTo((math.max(0, (index - 2))) * 72,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    final index2 =
        timeFormatList.indexWhere((element) => element == timeFormat);
    timeScrollController.animateTo((math.max(0, (index2 - 2))) * 72,
        duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    dateScrollController.dispose();
    timeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Date Time Format'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Date Format'.tr),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      controller: dateScrollController,
                      children: [
                        ...dateFormatList.map((e) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: RadioListTile(
                                value: e,
                                groupValue: dateFormat,
                                onChanged: (value) {
                                  setState(() {
                                    dateFormat = value!;
                                  });
                                },
                                selected: dateFormat == e,
                                title: Text(e),
                                shape: RoundedRectangleBorder(
                                    borderRadius: UiDimens.br12),
                                tileColor:
                                    Theme.of(context).colorScheme.surface,
                                selectedTileColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Time Format'.tr),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      controller: timeScrollController,
                      children: [
                        ...timeFormatList.map((e) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              child: RadioListTile(
                                value: e,
                                groupValue: timeFormat,
                                onChanged: (value) {
                                  setState(() {
                                    timeFormat = value!;
                                  });
                                },
                                selected: timeFormat == e,
                                title: Text(e),
                                shape: RoundedRectangleBorder(
                                    borderRadius: UiDimens.br12),
                                tileColor:
                                    Theme.of(context).colorScheme.surface,
                                selectedTileColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Preview'.tr),
                  ),
                  const Divider(),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: UiDimens.br12),
                    margin: EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: UiDimens.br12,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: Center(
                          child: LiveDateTimeDisplay(
                            dateFormat: dateFormat,
                            timeFormat: timeFormat,
                            fontSize: 24,
                            force2Line: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Opacity(
          opacity: dateFormat == appController.preferences.dateFormat &&
                  timeFormat == appController.preferences.timeFormat
              ? 0.4
              : 1,
          child: FloatingActionButton.extended(
            onPressed: dateFormat == appController.preferences.dateFormat &&
                    timeFormat == appController.preferences.timeFormat
                ? null
                : () {
                    appController.setPreferences(appController.preferences
                        .copyWith(
                            dateFormat: dateFormat, timeFormat: timeFormat));
                    RestartWidget.restartApp(context);
                  },
            elevation: dateFormat == appController.preferences.dateFormat &&
                    timeFormat == appController.preferences.timeFormat
                ? 0
                : null,
            icon: const Icon(Icons.save),
            label: Text('Save'.tr),
          ),
        ),
      );
    });
  }
}

import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/common/datetime_display.dart';
import 'package:central_heating_control/app/presentation/widgets/common/ht_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';

class DevDateTimeFormatSwitcherWidget extends StatelessWidget {
  const DevDateTimeFormatSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Date Format'.tr),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.amber.withValues(alpha: 128),
                  child: const LiveDateTimeDisplay(),
                ),
              ),
              const Spacer(),
              HtDropdown<String>(
                initialValue: app.preferences.dateFormat,
                options: StaticProvider.getDateFormatList,
                onSelected: (v) {
                  app.setPreferences(app.preferences.copyWith(
                    dateFormat: v,
                  ));
                  RestartWidget.restartApp(context);
                },
                labelBuilder: (dateFormat) => dateFormat,
              ),
              const SizedBox(width: 20),
              HtDropdown<String>(
                initialValue: app.preferences.timeFormat,
                options: StaticProvider.getTimeFormatList,
                onSelected: (v) {
                  app.setPreferences(app.preferences.copyWith(
                    timeFormat: v,
                  ));
                  RestartWidget.restartApp(context);
                },
                labelBuilder: (dateFormat) => dateFormat,
              ),
            ],
          ),
        ),
      );
    });
  }
}

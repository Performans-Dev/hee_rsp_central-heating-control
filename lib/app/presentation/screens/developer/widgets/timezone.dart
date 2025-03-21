import 'package:central_heating_control/app/core/extensions/restart.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/preferences/timezone.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/widgets/common/ht_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevTimezoneSwitcherWidget extends StatelessWidget {
  const DevTimezoneSwitcherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text('Timezone'.tr),
              const Spacer(),
              HtDropdown<Timezone>(
                initialValue: app.preferences.timezone,
                options: StaticProvider.getTimezoneList,
                onSelected: (v) {
                  app.setPreferences(app.preferences.copyWith(
                    timezone: v,
                  ));
                  RestartWidget.restartApp(context);
                },
                labelBuilder: (timezone) =>
                    '${timezone.name} (${timezone.gmt})',
              )
            ],
          ),
        ),
      );
    });
  }
}

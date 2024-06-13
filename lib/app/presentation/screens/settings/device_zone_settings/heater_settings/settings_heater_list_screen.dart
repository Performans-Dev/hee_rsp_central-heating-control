import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:central_heating_control/app/presentation/widgets/settings_heater_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsHeaterListScreen extends StatelessWidget {
  const SettingsHeaterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) => AppScaffold(
        title: 'Heaters',
        selectedIndex: 3,
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              // const BreadcrumbWidget(title: 'Settings / Heaters'),
              ListView.builder(
                itemBuilder: (context, index) =>
                    SettingsHeaterListItemWidget(heater: dc.heaterList[index]),
                itemCount: dc.heaterList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              addHeaterButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get addHeaterButton => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () {
            Buzz.feedback();
            Get.toNamed(Routes.settingsHeaterAdd);
          },
          child: const Text("Add New Heater"),
        ),
      );
}

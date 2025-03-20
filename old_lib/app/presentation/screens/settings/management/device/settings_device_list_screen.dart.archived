import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:central_heating_control/app/presentation/widgets/settings_heater_list_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsDeviceListScreen extends StatelessWidget {
  const SettingsDeviceListScreen({super.key});

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
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LabelWidget(
                    text: 'List of Heaters'.tr,
                  ),
                  addHeaterButton,
                ],
              ),
              // const BreadcrumbWidget(title: 'Settings / Heaters'),
              ListView.builder(
                itemBuilder: (context, index) =>
                    SettingsHeaterListItemWidget(heater: dc.heaterList[index]),
                itemCount: dc.heaterList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get addHeaterButton => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton.icon(
          onPressed: () {
            Buzz.feedback();
            Get.toNamed(Routes.settingsDeviceAdd);
          },
          label: const Text("Add New Heater"),
          icon: const Icon(Icons.add),
        ),
      );
}

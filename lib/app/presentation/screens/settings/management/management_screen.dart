import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/widgets/common/card_button_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Management'.tr,
      hasBackAction: true,
      selectedMenuIndex: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            CardButtonWidget(
              title: 'Zones'.tr,
              icon: Icons.hub,
              onTap: () {
                Get.toNamed(Routes.managementZones);
              },
              color: Theme.of(context).colorScheme.primary,
              size: CardSize.medium,
            ),
            CardButtonWidget(
              title: 'Devices'.tr,
              icon: Icons.device_hub,
              onTap: () {
                Get.toNamed(Routes.managementDevices);
              },
              color: Theme.of(context).colorScheme.secondary,
              size: CardSize.medium,
            ),
          ],
        ),
      ),
    );
  }
}

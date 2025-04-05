import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/widgets/common/card_button_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings'.tr,
      hasBackAction: true,
      selectedMenuIndex: 1,
      body: Padding(
        padding: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: [
            CardButtonWidget(
              title: 'Management'.tr,
              icon: Icons.device_hub,
              onTap: () {
                Get.toNamed(Routes.management);
              },
              color: Theme.of(context).colorScheme.primary,
            ),
            CardButtonWidget(
              title: 'Users'.tr,
              icon: Icons.people,
              onTap: () {
                Get.toNamed(Routes.appUsers);
              },
              color: Theme.of(context).colorScheme.secondary,
            ),
            CardButtonWidget(
              title: 'Preferences'.tr,
              icon: Icons.settings,
              onTap: () {
                Get.toNamed(Routes.preferences);
              },
              color: Theme.of(context).colorScheme.error,
            ),
            CardButtonWidget(
              title: 'Logs'.tr,
              icon: Icons.list,
              onTap: () {},
              color: Theme.of(context).colorScheme.tertiary,
              size: CardSize.small,
            ),
            CardButtonWidget(
              title: 'Triggers'.tr,
              icon: Icons.list,
              onTap: null,
              color: Theme.of(context).colorScheme.primary,
              size: CardSize.small,
            ),
            CardButtonWidget(
              title: 'Reports'.tr,
              icon: Icons.list,
              onTap: null,
              color: Theme.of(context).colorScheme.secondary,
              size: CardSize.small,
            ),
            CardButtonWidget(
              title: 'Advanced'.tr,
              icon: Icons.lock_outline,
              onTap: () {
                Get.toNamed(Routes.advanced);
              },
              color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
              size: CardSize.small,
            ),
          ],
        ),
      ),
    );
  }
}

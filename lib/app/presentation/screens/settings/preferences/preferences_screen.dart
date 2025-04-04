import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/widgets/common/card_button_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const size = CardSize.medium;
    return AppScaffold(
      title: 'Preferences'.tr,
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
              title: 'Theme'.tr,
              icon: Icons.format_paint,
              color: Theme.of(context).colorScheme.primary,
              onTap: () => Get.toNamed(Routes.preferencesTheme),
              size: size,
            ),
            CardButtonWidget(
              title: 'Language'.tr,
              icon: Icons.language,
              color: Theme.of(context).colorScheme.secondary,
              onTap: () => Get.toNamed(Routes.preferencesLanguage),
              size: size,
            ),
            CardButtonWidget(
              title: 'Timezone'.tr,
              icon: Icons.punch_clock,
              color: Theme.of(context).colorScheme.error,
              onTap: () => Get.toNamed(Routes.preferencesTimezone),
              size: size,
            ),
            CardButtonWidget(
              title: 'Date Time Format'.tr,
              icon: Icons.date_range,
              color: Theme.of(context).colorScheme.tertiary,
              onTap: () => Get.toNamed(Routes.preferencesDatetimeFormat),
              size: size,
            ),
            CardButtonWidget(
              title: 'Lock Screen'.tr,
              icon: Icons.lock_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
              onTap: () {},
              size: size,
            ),
            CardButtonWidget(
              title: 'Network Connections'.tr,
              icon: Icons.wifi,
              color: Theme.of(context).colorScheme.inverseSurface,
              onTap: () {},
              size: size,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/screens/settings/widgets/breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsZoneDeviceSensorManagementScreen extends StatelessWidget {
  const SettingsZoneDeviceSensorManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      selectedIndex: 3,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const BreadcrumbWidget(
            title: 'Settings/ Zone, Heaters, Sensor Management',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Zone'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Heaters'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    title: const Text('Sensor'),
                    trailing: const Icon(Icons.chevron_right),
                    tileColor: Theme.of(context).highlightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.sensorSettings);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

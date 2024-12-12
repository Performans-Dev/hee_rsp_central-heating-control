import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => AppScaffold(
        title: 'Settings',
        selectedIndex: 3,
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.dashboard_rounded),
                title: const Text('Zone, Heaters, Sensor Management'),
                subtitle:
                    const Text('Add/Modify/Remove zones, devices and sensors'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () {
                  //TODO: NavController.toZoneDeviceSensorManagement();
                  NavController.toSettingsManagement();
                },
              ),
              if (enabledFunctions) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.functions),
                  title: const Text('Functions'),
                  subtitle: const Text('Define custom functions and triggers'),
                  trailing: const Icon(Icons.chevron_right),
                  tileColor: Theme.of(context).highlightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () {},
                ),
              ],
              if (enabledWeeklyPlan) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.add_task),
                  title: const Text('Weekly Plan Settings'),
                  subtitle:
                      const Text('Define rules that runs on weekly schedule'),
                  trailing: const Icon(Icons.chevron_right),
                  tileColor: Theme.of(context).highlightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () => NavController.toSettingsWeeklySchedule(),
                ),
              ],
              if (enabledLocalUsers) ...[
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('User Management'),
                  subtitle: const Text('Add/Remove/Modify users and admins'),
                  trailing: const Icon(Icons.chevron_right),
                  tileColor: Theme.of(context).highlightColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  onTap: () => NavController.toSettingsUserList(),
                ),
              ],
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.settings_applications),
                title: const Text('Preferences'),
                subtitle: const Text(
                    'Themes, localizations, extension modules, updates'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => NavController.toSettingsPreferences(),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.list_alt_sharp),
                title: const Text('Logs'),
                subtitle: const Text('System and Device Logs'),
                trailing: const Icon(Icons.chevron_right),
                tileColor: Theme.of(context).highlightColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                onTap: () => NavController.toLogs(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

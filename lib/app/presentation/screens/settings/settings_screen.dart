import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/hardware_buttons.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => Scaffold(
        appBar: HomeAppBar(
          title: 'Settings',
        ),
        body: Stack(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Zone, Device, Sensor Management'),
                      subtitle:
                          Text('Add/Modify/Remove zones, devices and sensors'),
                      trailing: Icon(Icons.chevron_right),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text('Functions'),
                      subtitle: Text('Define custom functions and triggers'),
                      trailing: Icon(Icons.chevron_right),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text('Weekly Plan Settings'),
                      subtitle:
                          Text('Define rules that runs on weekly schedule'),
                      trailing: Icon(Icons.chevron_right),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text('User Management'),
                      subtitle: Text('Add/Remove/Modify users and admins'),
                      trailing: Icon(Icons.chevron_right),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () => NavController.toSettingsUserList(),
                    ),
                    SizedBox(height: 8),
                    ListTile(
                      title: Text('Preferences'),
                      subtitle: Text(
                          'Themes, localizations, extension modules, updates'),
                      trailing: Icon(Icons.chevron_right),
                      tileColor: Theme.of(context).highlightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () => NavController.toSettingsPreferences(),
                    ),
                  ],
                ),
              ),
            ),
            HwBtnBack(),
          ],
        ),
      ),
    );
  }
}

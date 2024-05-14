import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';

import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => AppScaffold(
        title: 'Settings',
        selectedIndex: 3,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
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
          ],
        ),
      ),
    );
  }
}

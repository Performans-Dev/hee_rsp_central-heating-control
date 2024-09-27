import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsPreferencesAdvancedHardwareConfigAddNewScreen
    extends StatelessWidget {
  const SettingsPreferencesAdvancedHardwareConfigAddNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: 'Add New Hardware',
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('pick from dropdown'),
          Text('display selected hw details'),
          Text('ask for serial number'),
          Text('confirm btn'),
        ],
      ),
    );
  }
}

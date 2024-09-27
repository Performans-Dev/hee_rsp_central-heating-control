import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesAdvancedHardwareConfigScreen extends StatelessWidget {
  const SettingsPreferencesAdvancedHardwareConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 3,
        title: 'Hardware Configuration',
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: dc.hardwareExtensionList.isEmpty
                  ? Center(
                      child: Text('no hardware installed'),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(dc.hardwareExtensionList[index].modelName),
                      ),
                      itemCount: dc.hardwareExtensionList.length,
                    ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(
                      Routes.settingsPreferencesAdvancedHardwareConfigAddNew);
                },
                label: Text('Add new hardware'),
                icon: Icon(Icons.add),
              ),
            ),
          ],
        ),
      );
    });
  }
}

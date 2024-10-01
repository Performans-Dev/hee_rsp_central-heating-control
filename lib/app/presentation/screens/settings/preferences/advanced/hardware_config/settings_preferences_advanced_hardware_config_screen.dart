import 'package:central_heating_control/app/core/utils/dialogs.dart';
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('List of installed hardwares'),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed(
                        Routes.settingsPreferencesAdvancedHardwareConfigAddNew);
                  },
                  label: const Text('Add new hardware'),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Expanded(
              child: dc.hardwareExtensionList.isEmpty
                  ? const Center(
                      child: Text('no hardware installed'),
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) => ListTile(
                        title: Text(dc.hardwareExtensionList[index].modelName),
                        leading: const Icon(Icons.hardware),
                        subtitle: Text(
                            'ID: ${dc.hardwareExtensionList[index].deviceId} Serial: ${dc.hardwareExtensionList[index].serialNumber}'),
                        trailing: IconButton(
                            onPressed: () {
                              DialogUtils.confirmDialog(
                                  context: context,
                                  title: 'Delete Hardware',
                                  description:
                                      'Are you sure you want to delete this hardware extension?',
                                  positiveText: 'Delete',
                                  negativeText: 'Cancel',
                                  positiveCallback: () async {
                                    await dc.deleteHardware(
                                        dc.hardwareExtensionList[index]);
                                  });
                            },
                            icon: const Icon(Icons.delete)),
                      ),
                      itemCount: dc.hardwareExtensionList.length,
                    ),
            ),
          ],
        ),
      );
    });
  }
}

import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesAdvancedHardwareConfigAddNewScreen
    extends StatefulWidget {
  const SettingsPreferencesAdvancedHardwareConfigAddNewScreen({super.key});

  @override
  State<SettingsPreferencesAdvancedHardwareConfigAddNewScreen> createState() =>
      _SettingsPreferencesAdvancedHardwareConfigAddNewScreenState();
}

class _SettingsPreferencesAdvancedHardwareConfigAddNewScreenState
    extends State<SettingsPreferencesAdvancedHardwareConfigAddNewScreen> {
  final DataController dataController = Get.find();
  late int nextHardwareId;

  bool busy = false;

  @override
  void initState() {
    super.initState();
    loadExistingHardwareExtensions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 3,
        title: 'Add New Hardware',
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
                'Connect your hardware and set its ID to $nextHardwareId. Hit continue when done.'),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    });
  }

  Future<void> loadExistingHardwareExtensions() async {
    setState(() => busy = true);
    await dataController.loadHardwareExtensions();
    nextHardwareId = 0;
    List<HardwareExtension> tmpList = dataController.hardwareExtensionList;
    tmpList.sort((a, b) => a.id.compareTo(b.id));
    if (tmpList.isNotEmpty) {
      nextHardwareId = tmpList.last.id + 1;
    }
    setState(() => busy = false);
  }
}

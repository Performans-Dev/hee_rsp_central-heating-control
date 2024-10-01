import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
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
  HardwareExtension? selectedHardwareExtension;
  late TextEditingController serialNumberController;
  late TextEditingController deviceIdController;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    serialNumberController = TextEditingController();
    deviceIdController = TextEditingController();
  }

  @override
  void dispose() {
    serialNumberController.dispose();
    deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: 'Add New Hardware',
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DropdownMenu<HardwareExtension>(
            enableFilter: false,
            enableSearch: false,
            expandedInsets: const EdgeInsets.all(8),
            leadingIcon: const Icon(Icons.hardware),
            dropdownMenuEntries: StaticProvider.availableHardwareExtensions
                .map((e) => DropdownMenuEntry<HardwareExtension>(
                    label: e.modelName, value: e))
                .toList(),
            label: const Text('Available Hardware Profiles'),
            onSelected: (value) {
              setState(() {
                selectedHardwareExtension = value;
              });
            },
          ),
          const Divider(),
          Expanded(
            child: selectedHardwareExtension == null
                ? const Center(
                    child: Text('Select a hardware profile from list'),
                  )
                : PiScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          subtitle: Text(
                              '${selectedHardwareExtension?.manufacturer}'),
                          title:
                              Text('${selectedHardwareExtension?.modelName}'),
                        ),
                        ListTile(
                          title: const Text('Input/Output Count'),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('DI: ${selectedHardwareExtension?.diCount}'),
                              const VerticalDivider(),
                              Text('DO: ${selectedHardwareExtension?.doCount}'),
                              const VerticalDivider(),
                              Text(
                                  'ADC: ${selectedHardwareExtension?.adcCount}'),
                              const VerticalDivider(),
                              Text(
                                  'DAC: ${selectedHardwareExtension?.dacCount}'),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('Connection'),
                          subtitle: Text(selectedHardwareExtension!
                              .connectionType
                              .map((e) => e.name)
                              .toList()
                              .join(', ')),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Expanded(
                              child: TextInputWidget(
                                controller: serialNumberController,
                                labelText: 'Serial number',
                              ),
                            ),
                            Expanded(
                              child: TextInputWidget(
                                controller: deviceIdController,
                                labelText: 'ID',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: busy
                                ? null
                                : () async {
                                    final DataController dataController =
                                        Get.find();
                                    setState(() {
                                      selectedHardwareExtension!.serialNumber =
                                          serialNumberController.text;
                                      selectedHardwareExtension!.deviceId =
                                          int.parse(deviceIdController.text);
                                      busy = true;
                                    });
                                    final result =
                                        await dataController.addNewHardware(
                                            selectedHardwareExtension!);
                                    setState(() => busy = false);
                                    if (context.mounted) {
                                      if (result > 0) {
                                        DialogUtils.snackbar(
                                            context: context,
                                            message:
                                                'Hardware Extension Profile saved',
                                            type: SnackbarType.success);
                                      } else {
                                        DialogUtils.snackbar(
                                            context: context,
                                            message: 'An error occured',
                                            type: SnackbarType.error);
                                      }
                                    }
                                  },
                            child: Text(busy ? 'Saving...' : 'Save'),
                          ),
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

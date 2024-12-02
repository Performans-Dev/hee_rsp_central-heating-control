import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

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
  String selectedTemperatureValueName = "";

  late TextEditingController serialNumberController;
  late TextEditingController deviceIdController;
  late TextEditingController gapController;
  late TextEditingController cofficientController;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    serialNumberController = TextEditingController();
    deviceIdController = TextEditingController();
    gapController = TextEditingController();
    cofficientController = TextEditingController();

    gapController.text = "0.0";
    cofficientController.text = "1.0";
  }

  @override
  void dispose() {
    serialNumberController.dispose();
    deviceIdController.dispose();
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
            const SizedBox(height: 8),
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
                            // trailing: Text(selectedHardwareExtension!
                            //     .connectionType
                            //     .map((e) => e.name)
                            //     .toList()
                            //     .join(', ')),
                          ),
                          ListTile(
                            title: const Text('Input/Output Count'),
                            subtitle: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'DI: ${selectedHardwareExtension?.diCount}'),
                                const VerticalDivider(),
                                Text(
                                    'DO: ${selectedHardwareExtension?.doCount}'),
                                const VerticalDivider(),
                                Text(
                                    'ADC: ${selectedHardwareExtension?.adcCount}'),
                                const VerticalDivider(),
                                Text(
                                    'DAC: ${selectedHardwareExtension?.dacCount}'),
                              ],
                            ),
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
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextInputWidget(
                                  controller: deviceIdController,
                                  labelText: 'ID',
                                  type: OSKInputType.number,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (dc.temperatureValues.isNotEmpty)
                                Expanded(
                                  child: DropdownMenu<String>(
                                    enableFilter: false,
                                    enableSearch: false,
                                    expandedInsets: const EdgeInsets.all(8),
                                    dropdownMenuEntries: dc.temperatureValues
                                        .map((e) => e.name)
                                        .toSet()
                                        .toList()
                                        .map((e) => DropdownMenuEntry<String>(
                                            label: e, value: e))
                                        .toSet()
                                        .toList(),
                                    label: const Text(
                                      'Temperature Value',
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        selectedTemperatureValueName = value!;
                                      });
                                    },
                                  ),
                                ),
                              const SizedBox(width: 6),

                              Expanded(
                                child: TextInputWidget(
                                  controller: gapController,
                                  labelText: 'Gap',
                                  type: OSKInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                flex: 1,
                                child: TextInputWidget(
                                  controller: cofficientController,
                                  labelText: 'Coefficient',
                                  type: OSKInputType.number,
                                ),
                              ),

                              //TODO: temperature value name dropdown
                              //TODO: gap
                              //TODO: coefficient
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            width: double.infinity,
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: null,

                              /* busy
                                  ? null
                                  : () async {
                                      final DataController dataController =
                                          Get.find();
                                      setState(() {
                                        selectedHardwareExtension!
                                                .serialNumber =
                                            serialNumberController.text;
                                        selectedHardwareExtension!.deviceId =
                                            int.parse(deviceIdController.text);
                                        selectedHardwareExtension!
                                                .tempValueName =
                                            selectedTemperatureValueName;

                                        selectedHardwareExtension!.gap =
                                            double.parse(gapController.text);
                                        selectedHardwareExtension!.coefficient =
                                            double.parse(
                                                cofficientController.text);
                                        //TODO: add temperatureVALUENAME+ COEFFİCİENT+GAP
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
                                          Get.back();
                                        } else {
                                          DialogUtils.snackbar(
                                              context: context,
                                              message: 'An error occured',
                                              type: SnackbarType.error);
                                        }
                                      }
                                    },*/
                              label: Text(busy ? 'Saving...' : 'Save'),
                              icon: busy
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Icon(
                                      Icons.save_alt,
                                      size: 24,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}

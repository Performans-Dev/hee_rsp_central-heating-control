import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
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
        body: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LabelWidget(
                    text: 'List of installed hardwares',
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.toNamed(Routes
                          .settingsPreferencesAdvancedHardwareConfigAddNew);
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
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          final HardwareExtension hw =
                              dc.hardwareExtensionList[index];
                          return Card(
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Icon(hw.deviceId == 0x00
                                      ? Icons.memory
                                      : Icons.developer_board),
                                  Text(
                                    hw.modelName,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(hw.manufacturer,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.grey)),
                                  Text(hw.description),
                                  Text(hw.serialNumber),
                                ],
                              ),
                            ),
                          );
                          /* trailing: PopupMenuButton(
                              child: const Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                //TODO: TEMPERATUREVALUENAME DEĞİŞTİRECEK DİALOG
                                //TODO: COEFFİCİENT DEĞİŞTİRECEK OSKKEYBOARD
                                //TODO: GAP DEĞİŞTİRECEK OSKKEYBOARD
                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Change Temperature Value'),
                                  ),
                                  onTap: () async {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        String newTemperatureValue = '';
                                        return AlertDialog(
                                          title: const Text(
                                              'Change Temperature Value'),
                                          content: DropdownMenu<String>(
                                            enableFilter: false,
                                            enableSearch: false,
                                            expandedInsets:
                                                const EdgeInsets.all(8),
                                            dropdownMenuEntries: dc
                                                .temperatureValues
                                                .map((e) => e.name)
                                                .toSet()
                                                .toList()
                                                .map((e) =>
                                                    DropdownMenuEntry<String>(
                                                        label: e, value: e))
                                                .toSet()
                                                .toList(),
                                            label: const Text(
                                              'Temperature Value',
                                            ),
                                            onSelected: (value) {
                                              Get.back(result: value);
                                            },
                                            initialSelection: hw.tempValueName,
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(newTemperatureValue);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (result != null && result.isNotEmpty) {
                                      try {
                                        await dc.changeTemperatureValueName(
                                            hw, result);

                                        if (context.mounted) {
                                          DialogUtils.snackbar(
                                            context: context,
                                            message:
                                                'Temperature value changed successfully',
                                            type: SnackbarType.success,
                                          );
                                        }
                                        await dc.loadHardwareExtensions();
                                      } catch (e) {
                                        if (context.mounted) {
                                          DialogUtils.snackbar(
                                            context: context,
                                            message:
                                                'Invalid input. Temperature value not saved',
                                            type: SnackbarType.error,
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),

                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Change Gap'),
                                  ),
                                  onTap: () async {
                                    final result = await OnScreenKeyboard.show(
                                      context: context,
                                      initialValue: hw.gap.toString(),
                                      type: OSKInputType.number,
                                    );
                                    if (result != null) {
                                      await dc.changeGapValue(
                                          hw, double.tryParse(result) ?? 0);
                                      if (context.mounted) {
                                        DialogUtils.snackbar(
                                          context: context,
                                          message: 'Gap Value saved',
                                          type: SnackbarType.success,
                                        );
                                      }
                                      await dc.loadHardwareExtensions();
                                      return;
                                    }
                                    if (context.mounted) {
                                      DialogUtils.snackbar(
                                        context: context,
                                        message:
                                            'An error occurred.Gap value not saved',
                                        type: SnackbarType.error,
                                      );
                                    }
                                  },
                                ),
                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Change Coefficient'),
                                  ),
                                  onTap: () async {
                                    final result = await OnScreenKeyboard.show(
                                        context: context,
                                        initialValue: hw.coefficient.toString(),
                                        type: OSKInputType.number);
                                    if (result != null) {
                                      await dc.changeCoefficientValue(
                                          hw, double.tryParse(result) ?? 1);
                                      if (context.mounted) {
                                        DialogUtils.snackbar(
                                          context: context,
                                          message: 'Coefficient saved',
                                          type: SnackbarType.success,
                                        );
                                      }
                                      await dc.loadHardwareExtensions();
                                      return;
                                    }
                                    if (context.mounted) {
                                      DialogUtils.snackbar(
                                        context: context,
                                        message:
                                            'An error occurred.Gap value not saved',
                                        type: SnackbarType.error,
                                      );
                                    }
                                  },
                                ),
                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Change Serial Number'),
                                  ),
                                  onTap: () async {
                                    final result = await OnScreenKeyboard.show(
                                      context: context,
                                      initialValue: hw.serialNumber,
                                    );
                                    if (result != null) {
                                      await dc.changeDeviceSerial(hw, result);
                                      if (context.mounted) {
                                        DialogUtils.snackbar(
                                          context: context,
                                          message: 'Device Serial Number saved',
                                          type: SnackbarType.success,
                                        );
                                      }
                                      await dc.loadHardwareExtensions();
                                      return;
                                    }
                                    if (context.mounted) {
                                      DialogUtils.snackbar(
                                        context: context,
                                        message:
                                            'An error occurred. Device Serial Number not saved',
                                        type: SnackbarType.error,
                                      );
                                    }
                                  },
                                ),
                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.edit),
                                    title: Text('Change Device ID'),
                                  ),
                                  onTap: () async {
                                    final result = await OnScreenKeyboard.show(
                                      context: context,
                                      initialValue: '${hw.deviceId}',
                                      type: OSKInputType.number,
                                    );
                                    if (result != null) {
                                      final value = int.parse(result);
                                      if (value > 0) {
                                        await dc.changeDeviceId(hw, value);
                                        if (context.mounted) {
                                          DialogUtils.snackbar(
                                            context: context,
                                            message: 'Device ID saved',
                                            type: SnackbarType.success,
                                          );
                                        }
                                        await dc.loadHardwareExtensions();
                                        return;
                                      }
                                    }
                                    if (context.mounted) {
                                      DialogUtils.snackbar(
                                        context: context,
                                        message:
                                            'An error occurred. Device ID not saved',
                                        type: SnackbarType.error,
                                      );
                                    }
                                  },
                                ),
                                PopupMenuItem(
                                  child: const ListTile(
                                    leading: Icon(Icons.delete),
                                    title: Text('Delete'),
                                  ),
                                  onTap: () {
                                    DialogUtils.confirmDialog(
                                        context: context,
                                        title: 'Delete Hardware',
                                        description:
                                            'Are you sure you want to delete this hardware extension?',
                                        positiveText: 'Delete',
                                        negativeText: 'Cancel',
                                        positiveCallback: () async {
                                          await dc.deleteHardware(hw);
                                        });
                                  },
                                ),
                              ],
                              onSelected: (value) {},
                            ), */
                          /* Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    final result = await OnScreenKeyboard.show(
                                      context: context,
                                      initialValue: dc
                                          .hardwareExtensionList[index]
                                          .serialNumber,
                                    );
                                    // update result
                                  },
                                  label: Text('SerialNumber'),
                                  icon: const Icon(Icons.edit),
                                ),
                                TextButton.icon(
                                  onPressed: () async {
                                    final result = await OnScreenKeyboard.show(
                                      context: context,
                                      initialValue: dc
                                          .hardwareExtensionList[index].deviceId,
                                    );
                                    // update result
                                  },
                                  label: Text('ID'),
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
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
                                              hw);
                                        });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ), */
                        },
                        itemCount: dc.hardwareExtensionList.length,
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsPreferencesAdvancedHardwareConfigScreen extends StatelessWidget {
  //TODO: controllerda kontrol et db de temperaturevalues boş ise içerik gösterme download butonunu göster.
  const SettingsPreferencesAdvancedHardwareConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 3,
        title: 'Hardware Configuration',
        body: dc.temperatureValues.isEmpty
            ? Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await dc.loadTemperatureValues();
                    //
                  },
                  label: const Text('Load Profiles'),
                  icon: const Icon(Icons.download),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('List of installed hardwares',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium), //TODO: Apply title style here

                      ElevatedButton.icon(
                        onPressed: () async {
                          await AppProvider.downloadTemperatureValues();
                          //
                        },
                        label: const Text('Load Profiles'),
                        icon: const Icon(Icons.download),
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
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final HardwareExtension hw =
                                  dc.hardwareExtensionList[index];
                              List<String> connectionNames = [];
                              for (final item in hw.connectionType) {
                                connectionNames
                                    .add(item.name.camelCaseToHumanReadable());
                              }
                              return ListTile(
                                title: Text(hw.modelName),
                                leading: CircleAvatar(
                                  child: Text('${hw.deviceId}'),
                                ),
                                subtitle: Text('${connectionNames.join(',')} '
                                    '[ sn:${hw.serialNumber}, g:${hw.gap}, c:${hw.coefficient}, n:${hw.tempValueName}]'),
                                trailing: PopupMenuButton(
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
                                                        DropdownMenuEntry<
                                                                String>(
                                                            label: e, value: e))
                                                    .toSet()
                                                    .toList(),
                                                label: const Text(
                                                  'Temperature Value',
                                                ),
                                                onSelected: (value) {
                                                  Get.back(result: value);
                                                },
                                                initialSelection:
                                                    hw.tempValueName,
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
                                                    Navigator.of(context).pop(
                                                        newTemperatureValue);
                                                  },
                                                  child: const Text('Save'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (result != null &&
                                            result.isNotEmpty) {
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
                                        final result =
                                            await OnScreenKeyboard.show(
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
                                        final result =
                                            await OnScreenKeyboard.show(
                                                context: context,
                                                initialValue:
                                                    hw.coefficient.toString(),
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
                                        final result =
                                            await OnScreenKeyboard.show(
                                          context: context,
                                          initialValue: hw.serialNumber,
                                        );
                                        if (result != null) {
                                          await dc.changeDeviceSerial(
                                              hw, result);
                                          if (context.mounted) {
                                            DialogUtils.snackbar(
                                              context: context,
                                              message:
                                                  'Device Serial Number saved',
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
                                        final result =
                                            await OnScreenKeyboard.show(
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
                                ),
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
                              );
                            },
                            itemCount: dc.hardwareExtensionList.length,
                          ),
                  ),
                ],
              ),
      );
    });
  }
}

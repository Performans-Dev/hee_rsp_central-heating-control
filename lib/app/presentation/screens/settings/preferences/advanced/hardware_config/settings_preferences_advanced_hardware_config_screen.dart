import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/hardware_extension.dart';
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                    'List of installed hardwares'), //TODO: Apply title style here
                ///TODO: app providera yaz
                /// DOwnload temperature json buton (bu buton jsonu db ye yazacak.
                ///  yazmadan önce haliyle boşaltacak. eski değerleri silip yenisini yazacak.)
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
                              '[${hw.serialNumber}]'),
                          trailing: PopupMenuButton(
                            child: const Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                              //TODO: TEMPERATUREVALUENAME DEĞİŞTİRECEK DİALOG
                              //TODO: COEFFİCİENT DEĞİŞTİRECEK OSKKEYBOARD
                              //TODO: GAP DEĞİŞTİRECEK OSKKEYBOARD

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

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/device_add_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_state_view.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagementDeviceDetailScreen extends StatefulWidget {
  const ManagementDeviceDetailScreen({super.key, required this.device});
  final Device device;

  @override
  State<ManagementDeviceDetailScreen> createState() =>
      _ManagementDeviceDetailScreenState();
}

class _ManagementDeviceDetailScreenState
    extends State<ManagementDeviceDetailScreen> {
  late Device device;
  final AppController appController = Get.find();

  @override
  void initState() {
    super.initState();
    device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: device.name,
        hasBackAction: true,
        selectedMenuIndex: 1,
        floatingActionButton: FabWidget(
          onPressed: () {
            Get.to(() => ManagementDeviceAddScreen(device: device));
          },
          label: 'Edit Device'.tr,
          icon: Icons.edit,
          heroTag: 'edit_device',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              ListTile(
                title: Text(device.name),
                leading: DeviceIconWidget(icon: device.icon),
                subtitle: Text(device.groupName ?? '-'),
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: UiDimens.br12,
                ),
              ),
              InvertedListTileWidget(
                shape: RoundedRectangleBorder(
                  borderRadius: UiDimens.br12,
                ),
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                title: Text('State Map'.tr),
                subtitle: DeviceStateViewWidget(device: device),
              ),
            ],
          ),
        ),
      );
    });
  }

  // Future<void> onEditNameSelected() async {
  //   final result = await OnScreenKeyboard.show(
  //     context: context,
  //     initialValue: device.name,
  //     hintText: 'Type a name for this device'.tr,
  //     maxLength: 20,
  //     minLength: 3,
  //     type: OSKInputType.name,
  //     label: 'Device name'.tr,
  //   );
  //   if (result != null && mounted) {
  //     setState(() {
  //       didChanged = result != widget.device.name;
  //       device = device.copyWith(name: result);
  //     });
  //   }
  // }

  // Future<void> onEditIconSelected() async {
  //   await DialogUtils.iconPickerDialog(
  //     initialValue: device.icon,
  //     onSelected: (value) {
  //       if (mounted) {
  //         setState(() {
  //           didChanged = value != widget.device.icon;
  //           device = device.copyWith(icon: value);
  //         });
  //       }
  //     },
  //   );
  // }

  // Future<void> onEditGroupSelected() async {
  //   await DialogUtils.groupPickerDialog(
  //     initialValue: device.groupId,
  //     onSelected: (value) {
  //       if (mounted) {
  //         setState(() {
  //           didChanged = value != widget.device.groupId;
  //           device = device.copyWith(groupId: value);
  //         });
  //       }
  //     },
  //   );
  // }

  // Future<void> onDeleteDeviceSelected() async {
  //   return await DialogUtils.showConfirmDialog(
  //     context: context,
  //     title: 'Delete Device'.tr,
  //     message: 'Are you sure you want to delete this device?'.tr,
  //     onConfirm: () async {
  //       await appController.deleteDevice(device.id);
  //       Get.back();
  //     },
  //   );
  // }

  // Future<void> onEditInputOutputLevelSelected() async {
  //   final result = await DialogUtils.showContentDialog(
  //     context: context,
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       spacing: 16,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Level Count'.tr),
  //             HtDropdown<int>(
  //               initialValue: device.levelCount,
  //               options: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
  //               onSelected: (value) {
  //                 setState(() {
  //                   device = device.copyWith(levelCount: value);
  //                   List<DeviceLevel> deviceLevels = [];
  //                   for (int i = 0; i <= value + 1; i++) {
  //                     deviceLevels.add(DeviceLevel(
  //                         level: i, name: i == 0 ? 'OFF' : 'Lvl $i'));
  //                   }
  //                   device = device.copyWith(levels: deviceLevels);
  //                   didChanged = true;
  //                 });

  //                 calculateStates();
  //               },
  //               labelBuilder: (value) => value.toString(),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Output Count'),
  //             HtDropdown<int>(
  //               initialValue: device.outputCount,
  //               options: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
  //               onSelected: (value) {
  //                 setState(() {
  //                   device = device.copyWith(outputCount: value);
  //                   didChanged = true;
  //                 });
  //               },
  //               labelBuilder: (value) => value.toString(),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text('Input Count'),
  //             HtDropdown<int>(
  //               initialValue: device.inputCount,
  //               options: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
  //               onSelected: (value) {
  //                 setState(() {
  //                   device = device.copyWith(inputCount: value);
  //                   didChanged = true;
  //                 });
  //               },
  //               labelBuilder: (value) => value.toString(),
  //             ),
  //           ],
  //         ),
  //         Row(
  //           children: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 Get.back(result: true);
  //               },
  //               child: Text('Next'),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );

  //   if (result == true && mounted) {
  //     final result = await DialogUtils.showContentDialog(
  //       context: context,
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.stretch,
  //         spacing: 16,
  //         children: [
  //           Wrap(
  //             spacing: 12,
  //             children: [
  //               for (int i = 0; i <= device.levelCount; i++)
  //                 SizedBox(
  //                   width: 160,
  //                   child: InvertedListTileWidget(
  //                     contentPadding: EdgeInsets.zero,
  //                     title: Text('Level $i'.tr),
  //                     subtitle: HtTextField(
  //                       initialValue: device.levels.length > i
  //                           ? device.levels[i].name
  //                           : '',
  //                       onTap: () async {
  //                         final result = await OnScreenKeyboard.show(
  //                           context: context,
  //                           initialValue: device.levels.length > i
  //                               ? device.levels[i].name
  //                               : '',
  //                           hintText: 'Type a name for this level'.tr,
  //                           maxLength: 20,
  //                           minLength: 1,
  //                           type: OSKInputType.name,
  //                           label: 'Level $i name'.tr,
  //                         );
  //                         if (result != null && mounted) {
  //                           DeviceLevel deviceLevel = device.levels.length > i
  //                               ? device.levels[i].copyWith(name: result)
  //                               : DeviceLevel(level: i, name: result);
  //                           List<DeviceLevel> deviceLevels = device.levels;
  //                           deviceLevels.replaceRange(i, i + 1, [deviceLevel]);

  //                           setState(() {
  //                             device = device.copyWith(
  //                               levels: deviceLevels,
  //                             );
  //                           });
  //                         }
  //                       },
  //                     ),
  //                   ),
  //                 )
  //             ],
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               Get.back(result: true);
  //             },
  //             child: Text('Next'),
  //           )
  //         ],
  //       ),
  //     );
  //   }
  // }

  // Future<void> onEditStateMapSelected() async {
  //   DialogUtils.showContentDialog(
  //     context: context,
  //     content: DeviceStateViewWidget(
  //       deviceLevelCount: device.levelCount,
  //       deviceOutputCount: device.outputCount,
  //       deviceInputCount: device.inputCount,
  //       deviceLevels: device.levels,
  //       deviceOutputs: device.deviceOutputs,
  //       deviceInputs: device.deviceInputs,
  //       onOutputStateChange: (i, value) {
  //         List<DeviceOutput> outputs = device.deviceOutputs;
  //         outputs[i] = outputs[i].copyWith(outputId: value);
  //         setState(() {
  //           device = device.copyWith(deviceOutputs: outputs);
  //         });
  //       },
  //       onInputStateChange: (i, value) {
  //         List<DeviceInput> inputs = device.deviceInputs;
  //         inputs[i] = inputs[i].copyWith(inputId: value);
  //         setState(() {
  //           device = device.copyWith(deviceInputs: inputs);
  //         });
  //       },
  //       outputLevelStates: outputLevelStates,
  //       inputLevelStates: inputLevelStates,
  //       onOutputStateValueChange: (i, j, value) {
  //         setState(() {
  //           outputLevelStates
  //               .firstWhere((e) => e.state == i && e.portId == j)
  //               .value = value;
  //         });
  //       },
  //       onInputStateValueChange: (i, j, value) {
  //         setState(() {
  //           inputLevelStates
  //               .firstWhere((e) => e.state == i && e.portId == j)
  //               .value = value;
  //         });
  //       },
  //     ),
  //   );
  // }

  // Future<void> saveDevice() async {
  //   await appController.saveDevice(device);
  //   Get.back();
  // }

  // MARK: calculate states
  // void calculateStates() {
  //   outputLevelStates = [];
  //   inputLevelStates = [];
  //   for (int i = 0; i <= device.levelCount; i++) {
  //     for (int j = 0; j < device.outputCount; j++) {
  //       outputLevelStates.add(LevelStateDefinition(
  //         state: i,
  //         portId: j,
  //         value: false,
  //       ));
  //     }
  //     for (int j = 0; j < device.inputCount; j++) {
  //       inputLevelStates.add(LevelStateDefinition(
  //         state: i,
  //         portId: j,
  //         value: false,
  //       ));
  //     }
  //   }
  //   setState(() {});
  // }
}

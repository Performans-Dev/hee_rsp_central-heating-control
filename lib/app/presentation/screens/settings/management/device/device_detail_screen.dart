import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/dialog_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/screens/common/icon_picker_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

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
          onPressed: () => Get.back(),
          label: 'Save'.tr,
          icon: Icons.save,
          heroTag: 'save_device',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(device.name),
                leading: DeviceIconWidget(icon: device.icon),
                trailing: PopupMenuButton<int>(
                  onSelected: (int value) {
                    if (value == 0) {
                      onEditNameSelected();
                    } else if (value == 1) {
                      onEditIconSelected();
                    } else if (value == 2) {
                      onEditGroupSelected();
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(
                        value: 0, child: Text('Change Device Name')),
                    const PopupMenuItem<int>(
                        value: 1, child: Text('Change Device Icon')),
                    const PopupMenuItem<int>(
                        value: 2, child: Text('Change Group')),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
                subtitle: Text(device.groupName ?? '-'),
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: UiDimens.br12,
                ),
              ),
              const Text('levelCount'),
              const Text('level names'),
              const Text('outputCount'),
              const Text('inputCount'),
              const Text('matrix'),
              Text('Edit Device'.tr),
            ],
          ),
        ),
      );
    });
  }

  Future<void> onEditNameSelected() async {
    final result = await OnScreenKeyboard.show(
      context: context,
      initialValue: device.name,
      hintText: 'Type a name for this device'.tr,
      maxLength: 20,
      minLength: 3,
      type: OSKInputType.name,
      label: 'Device name'.tr,
    );
    if (result != null && mounted) {
      setState(() {
        device = device.copyWith(name: result);
      });
    }
  }

  Future<void> onEditIconSelected() async {
    await DialogUtils.iconPickerDialog(
      initialValue: device.icon,
      onSelected: (value) {
        setState(() {
          device = device.copyWith(icon: value);
        });
      },
    );
  }

  Future<void> onEditGroupSelected() async {
    final result = await DialogUtils.groupPickerDialog(
      initialValue: device.groupId,
      onSelected: (value) {
        setState(() {
          device = device.copyWith(groupId: value);
        });
      },
    );
  }
}

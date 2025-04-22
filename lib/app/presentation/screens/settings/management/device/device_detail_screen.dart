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
}

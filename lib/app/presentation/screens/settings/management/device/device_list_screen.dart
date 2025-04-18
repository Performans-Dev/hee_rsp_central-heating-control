import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/device_detail_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_list_tile.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagementDeviceListScreen extends StatelessWidget {
  const ManagementDeviceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Devices'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        floatingActionButton: FabWidget(
          onPressed: () => Get.toNamed(Routes.managementAddDevice),
          label: 'Add Device'.tr,
          icon: Icons.add,
          heroTag: 'add_device',
        ),
        body: app.devices.isEmpty
            ? Center(child: Text('No devices'.tr))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: app.devices.length,
                itemBuilder: (context, index) {
                  final device = app.devices[index];
                  return DeviceListTileWidget(
                    device: device,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  );
                },
              ),
      );
    });
  }
}

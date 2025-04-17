import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
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
              const Text('name'),
              const Text('icon'),
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
}

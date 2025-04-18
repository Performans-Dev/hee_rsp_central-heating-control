import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/device_detail_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceListTileWidget extends StatelessWidget {
  const DeviceListTileWidget({super.key, required this.device, this.margin});
  final Device device;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ListTile(
        title: Text(device.name),
        leading: DeviceIconWidget(icon: device.icon),
        trailing: const Icon(Icons.chevron_right),
        subtitle: Text(device.groupName ?? '-'),
        onTap: () => Get.to(() => ManagementDeviceDetailScreen(device: device)),
        shape: RoundedRectangleBorder(
          borderRadius: UiDimens.br12,
        ),
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
    );
  }
}

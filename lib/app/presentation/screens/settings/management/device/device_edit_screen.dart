import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/widgets/common/ht_dropdown.dart';
import 'package:central_heating_control/app/presentation/widgets/common/icon_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/textfield.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class ManagementDeviceEditScreen extends StatefulWidget {
  const ManagementDeviceEditScreen({super.key});

  @override
  State<ManagementDeviceEditScreen> createState() =>
      _ManagementDeviceEditScreenState();
}

class _ManagementDeviceEditScreenState
    extends State<ManagementDeviceEditScreen> {
  final AppController appController = Get.find();
  late Device device;

  @override
  void initState() {
    super.initState();
    int deviceId = Get.arguments?['deviceId']?.toInt() ?? -1;
    device = appController.devices.firstWhere((e) => e.id == deviceId);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Edit Device'.tr,
      hasBackAction: true,
      selectedMenuIndex: 3,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: InvertedListTileWidget(
                    title: Text('Name'),
                    subtitle: HtTextField(
                      initialValue: device.name,
                      onTap: () async {
                        final result = await OnScreenKeyboard.show(
                          context: context,
                          initialValue: device.name,
                          label: 'Device name'.tr,
                          minLength: 3,
                          maxLength: 20,
                          type: OSKInputType.name,
                          hintText: 'Type a name for this device'.tr,
                        );
                        if (result != null) {
                          setState(() {
                            device = device.copyWith(name: result);
                          });
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: InvertedListTileWidget(
                    title: Text('Icon'),
                    subtitle: DeviceIconWidget(icon: device.icon),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InvertedListTileWidget(
                    title: Text('Group'),
                    subtitle: HtDropdown<int?>(
                      initialValue: device.groupId,
                      options: appController.groups.map((e) => e.id).toList(),
                      onSelected: (value) {
                        setState(() {
                          device = device.copyWith(groupId: value);
                        });
                      },
                      labelBuilder: (value) => value == null
                          ? '-'
                          : appController.groups
                              .firstWhere((e) => e.id == value)
                              .name,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

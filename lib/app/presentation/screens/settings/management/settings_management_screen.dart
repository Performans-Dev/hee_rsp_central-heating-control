import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/channel.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsManagementScreen extends StatelessWidget {
  const SettingsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Zones, Heaters, Sensors',
      selectedIndex: 3,
      body: PiScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Zone'),
              subtitle: Text('List and manage zones'.tr),
              trailing: const Icon(Icons.chevron_right),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                NavController.toSettingsZoneList();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Heaters'),
              subtitle: Text('List and manage heaters'.tr),
              trailing: const Icon(Icons.chevron_right),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                NavController.toSettingsDeviceList();
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text('Sensor'),
              subtitle: Text('List and manage sensors'.tr),
              trailing: const Icon(Icons.chevron_right),
              tileColor: Theme.of(context).highlightColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onTap: () {
                NavController.toSettingsSensorList();
              },
            ),
            const SizedBox(height: 8),
            GetBuilder<ChannelController>(builder: (cc) {
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: Theme.of(context).highlightColor,
                title: const Text('Alarm'),
                subtitle: Text('Configure alarm input'.tr),
                trailing: SizedBox(
                  width: 100,
                  child: ChannelDropdownWidget(
                    group: GpioGroup.inPin,
                    value: null, //TODO: read from db via data controller
                    onChanged: (value) {
                      //TODO: save to db via data controller
                    },
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

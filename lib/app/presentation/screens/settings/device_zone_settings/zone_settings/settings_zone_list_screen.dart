import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsZoneListScreen extends StatelessWidget {
  const SettingsZoneListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        title: 'Zones',
        selectedIndex: 3,
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BreadcrumbWidget(
                title: 'Settings / Zones',
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  tileColor:
                      CommonUtils.hexToColor(context, dc.zoneList[index].color)
                          .withOpacity(0.3),
                  title: Text(dc.zoneList[index].name),
                  subtitle: Text(dc.zoneList[index].users
                      .map((e) => e.username)
                      .toList()
                      .join(', ')
                      .toString()),
                  trailing: const Text('Edit button'),
                  onTap: () {
                    Buzz.feedback();
                    Get.toNamed(
                      Routes.settingsZoneEdit,
                      parameters: {
                        'id': dc.zoneList[index].id.toString(),
                      },
                    );
                  },
                ),
                itemCount: dc.zoneList.length,
              ),
              addZoneButton,
            ],
          ),
        ),
      );
    });
  }

  Widget get addZoneButton => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () {
            Buzz.feedback();
            Get.toNamed(Routes.settingsZoneAdd);
          },
          child: const Text("Add New Zone"),
        ),
      );
}

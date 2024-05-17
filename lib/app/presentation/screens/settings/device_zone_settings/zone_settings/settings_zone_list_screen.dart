import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const BreadcrumbWidget(
              title: 'Settings / Zones',
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  tileColor: CommonUtils.hexToColor(dc.zoneList[index].color)
                      .withOpacity(0.3),
                  title: Text(dc.zoneList[index].name),
                  subtitle: Text(dc.zoneList[index].users
                      .map((e) => e.username)
                      .toList()
                      .join(', ')
                      .toString()),
                  trailing: Text('Edit button'),
                ),
                itemCount: dc.zoneList.length,
              ),
            ),
            addZoneButton,
          ],
        ),
      );
    });
  }

  Widget get addZoneButton => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(Routes.settingsZoneAdd),
          child: const Text("Add New Zone"),
        ),
      );
}

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPlanListScreen extends StatelessWidget {
  const SettingsPlanListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 3,
        title: 'Plan List',
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BreadcrumbWidget(title: 'Settings / Plan List'),
              ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(dc.planList[index].name),
                  leading: Icon(
                    Icons.check,
                    color: dc.planList[index].isActive == 1
                        ? Colors.green
                        : Colors.grey.withOpacity(0.3),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed:
                            dc.planList[index].isDefault == 1 ? null : () {},
                        icon: const Icon(Icons.delete),
                      ),
                      IconButton(
                        onPressed:
                            dc.planList[index].isDefault == 1 ? null : () {},
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.copy),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.toNamed(
                            Routes.settingsPlanDetail,
                            parameters: {
                              'planId': dc.planList[index].id.toString(),
                            },
                          );
                        },
                        icon: const Icon(Icons.zoom_in),
                      ),
                    ],
                  ),
                ),
                itemCount: dc.planList.length,
                shrinkWrap: true,
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Add New Plan'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

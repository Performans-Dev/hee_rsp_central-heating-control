import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsFunctionListScreen extends StatelessWidget {
  const SettingsFunctionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        selectedIndex: 3,
        title: 'Functions',
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Row(
                  children: [
                    const Text('Function List'),
                    TextButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.settingsFunctionAdd);
                      },
                      label: const Text('Add New Function'),
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
              const Divider(),
              ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(dc.functionList[index].name),
                ),
                itemCount: dc.functionList.length,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      );
    });
  }
}

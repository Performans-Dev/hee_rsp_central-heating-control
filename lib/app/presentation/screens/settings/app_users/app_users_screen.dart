import 'package:central_heating_control/app/data/controllers/app_user.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUsersScreen extends StatelessWidget {
  const AppUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUserController>(builder: (auc) {
      return AppScaffold(
        title: 'Users'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(auc.appUsers[index].name),
          ),
          itemCount: auc.appUsers.length,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed(Routes.addNewAppUser);
          },
          label: Text('Add User'.tr),
          icon: const Icon(Icons.add),
        ),
      );
    });
  }
}

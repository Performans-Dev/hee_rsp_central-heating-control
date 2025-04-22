import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/group/group_detail_screen.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagementZoneListScreen extends StatelessWidget {
  const ManagementZoneListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Groups'.tr,
        hasBackAction: true,
        selectedMenuIndex: 3,
        body: app.groups.isEmpty
            ? Center(child: Text('No groups found'.tr))
            : ListView.separated(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                itemBuilder: (context, index) => ListTile(
                  title: Text(app.groups[index].name),
                  onTap: () => Get.to(() =>
                      ManagementGroupDetailScreen(group: app.groups[index])),
                  tileColor: ColorUtils.itemColorWithValue(
                      context, app.groups[index].color),
                  shape: RoundedRectangleBorder(borderRadius: UiDimens.br12),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: app.groups.length,
              ),
        floatingActionButton: FabWidget(
          onPressed: () => Get.to(() => const ManagementGroupDetailScreen()),
          label: 'Add New Group'.tr,
          icon: Icons.add,
          heroTag: 'add_zone',
        ),
      );
    });
  }
}

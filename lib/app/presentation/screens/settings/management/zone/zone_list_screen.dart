import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
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
        title: 'Zones'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        body: app.zones.isEmpty
            ? const Center(child: Text('No zones found'))
            : ListView.separated(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                itemBuilder: (context, index) => ListTile(
                  title: Text(app.zones[index].name),
                  onTap: () => Get.toNamed(
                      '/settings/management/zone/${app.zones[index].id}'),
                  tileColor: ColorUtils.itemColorWithValue(
                      context, app.zones[index].color),
                  shape: RoundedRectangleBorder(borderRadius: UiDimens.br12),
                ),
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: app.zones.length,
              ),
        floatingActionButton: FabWidget(
          onPressed: () {},
          label: 'Add New Zone'.tr,
          icon: Icons.add,
          heroTag: 'add_zone',
        ),
      );
    });
  }
}

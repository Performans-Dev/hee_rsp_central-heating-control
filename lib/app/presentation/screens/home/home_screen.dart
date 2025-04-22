import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/presentation/screens/group/group_screen.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// this is the dashboard
///
/// displays a list of groups
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      int length = app.groups.length;
      double height = 120;
      int crossAxisCount = 3;
      if (length < 7) {
        height = 180;
      }
      if (length < 5) {
        crossAxisCount = 2;
      }
      return AppScaffold(
        body: Stack(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: height,
              ),
              itemBuilder: (context, index) => GroupCard(
                group: app.groups[index],
                deviceIcons: app.devices
                    .where((d) => d.groupId == app.groups[index].id)
                    .map((d) => d.icon)
                    // .take(crossAxisCount > 2 ? 4 : 2)
                    .toList(),
              ),
              itemCount: app.groups.length,
              shrinkWrap: true,
            ),
          ],
        ),
        title: 'Home'.tr,
      );
    });
  }
}

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.group, this.deviceIcons});
  final GroupDefinition group;
  final List<String?>? deviceIcons;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4),
      shape: RoundedRectangleBorder(
        borderRadius: UiDimens.br12,
      ),
      child: ClipRRect(
        borderRadius: UiDimens.br12,
        child: InkWell(
          borderRadius: UiDimens.br12,
          onTap: () => Get.to(() => GroupScreen(group: group)),
          child: Container(
            decoration: BoxDecoration(
              color: ColorUtils.itemColorWithValue(
                context,
                group.color,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          group.name,
                          style: const TextStyle(fontSize: 28, shadows: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 3,
                              offset: Offset(0, 0),
                            )
                          ]),
                        ),
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            ...?deviceIcons?.map((icon) => DeviceIconWidget(
                                  icon: icon,
                                  background: ColorUtils.itemColorWithValue(
                                    context,
                                    group.color,
                                  ).withValues(alpha: 0.2),
                                  radius: 14,
                                  size: 18,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '24.2°C',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Text('SET: 25.0°C',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer
                                    .withValues(alpha: 0.4))),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'OFF',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.2),
                            ),
                            Icon(
                              Icons.sunny,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

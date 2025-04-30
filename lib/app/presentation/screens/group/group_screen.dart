import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// receives a group Id, and displays the group details
/// adjusts group controls
/// lists group devices
/// adjusts device controls
class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key, required this.group});
  final GroupDefinition group;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      GroupDefinition g = app.groups.firstWhere((e) => e.id == group.id);
      final List<Device> devices =
          app.devices.where((e) => e.groupId == g.id).toList();
      int maxLevel = 0;
      for (final device in devices) {
        maxLevel = maxLevel < device.levelCount ? device.levelCount : maxLevel;
      }

      List<bool> levelValues =
          List.generate(maxLevel, (index) => index == g.adjustedLevel);
      return AppScaffold(
        selectedMenuIndex: 0,
        hasBackAction: true,
        title: g.name,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: ColorUtils.itemColorWithValue(
                  context,
                  g.color,
                ),
              ),
              child: Row(
                spacing: 12,
                children: [
                  const Text('24.2°C'),
                  const Icon(Icons.remove),
                  Text('SET: ${g.thermostatTemperature}°C'),
                  const Spacer(),
                  Text('[${devices.length} / $maxLevel]'),
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
                  Text(g.adjustedLevel == 0 ? 'OFF' : 'ON')
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: Card(
                      child: Container(
                        constraints: const BoxConstraints.expand(),
                        child: Center(
                          child: ToggleButtons(
                            verticalDirection: VerticalDirection.up,
                            direction: Axis.vertical,
                            onPressed: (index) {
                              app.setGroup(g.copyWith(
                                adjustedLevel: index,
                              ));
                            },
                            isSelected: [...levelValues, false],
                            children: [
                              ...List.generate(
                                maxLevel,
                                (index) => Text(
                                  (index).toString(),
                                ),
                              ),
                              const Text('AUTO'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      padding:
                          const EdgeInsets.only(right: 16, top: 12, bottom: 12),
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: UiDimens.br12),
                          tileColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          title: Text(devices[index].name),
                          subtitle: ToggleButtons(
                            constraints: const BoxConstraints(
                                maxHeight: 40, minWidth: 48),
                            borderRadius: UiDimens.br12,
                            onPressed: (index) {
                              //
                            },
                            isSelected: [
                              ...devices[index]
                                  .levels
                                  .map((e) => e.level == g.adjustedLevel)
                                  .toList(),
                              false,
                            ],
                            children: [
                              ...devices[index]
                                  .levels
                                  .map((e) => Text(e.name))
                                  .toList(),
                              const Text('AUTO'),
                            ],
                          ),
                          leading: DeviceIconWidget(icon: devices[index].icon),
                        ),
                        itemCount: devices.length,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

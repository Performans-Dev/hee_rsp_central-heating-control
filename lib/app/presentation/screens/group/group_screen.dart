import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';

/// receives a group Id, and displays the group details
/// adjusts group controls
/// lists group devices
/// adjusts device controls
class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key, required this.group});
  final GroupDefinition group;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedMenuIndex: 0,
      hasBackAction: true,
      title: group.name,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: ColorUtils.itemColorWithValue(
                context,
                group.color,
              ),
            ),
            child: Row(
              spacing: 12,
              children: [
                const Text('24.2°C'),
                const Icon(Icons.remove),
                const Text('SET: 25.0°C'),
                const Spacer(),
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
                const Text('OFF')
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('asdf'),
            ),
          )
        ],
      ),
    );
  }
}

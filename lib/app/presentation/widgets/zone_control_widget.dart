import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:flutter/material.dart';

class ZoneControlWidget extends StatelessWidget {
  const ZoneControlWidget({
    super.key,
    required this.maxLevel,
    required this.currentState,
    required this.onStateChanged,
  });
  final int maxLevel;
  final HeaterState currentState;
  final Function(HeaterState state) onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildRow(context, HeaterState.auto),
        buildRow(context, HeaterState.level3),
        buildRow(context, HeaterState.level2),
        buildRow(context, HeaterState.level1),
        buildRow(context, HeaterState.off),
      ],
    );
  }

  Widget buildRow(context, HeaterState state) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: kToolbarHeight,
          padding: const EdgeInsets.all(4),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Container(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        Text(CCUtils.stateDisplay(state)),
        const Spacer(),
      ],
    );
  }
}

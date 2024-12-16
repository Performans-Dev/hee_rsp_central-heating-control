import 'package:central_heating_control/app/core/constants/dimens.dart';
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
        if (maxLevel >= 3) buildRow(context, HeaterState.level3),
        if (maxLevel >= 2) buildRow(context, HeaterState.level2),
        buildRow(context, HeaterState.level1),
        buildRow(context, HeaterState.off),
      ],
    );
  }

  Widget buildRow(context, HeaterState state) {
    BorderRadius radius = BorderRadius.circular(0);
    if (state == HeaterState.off) {
      radius = const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    } else if (state == HeaterState.auto) {
      radius = const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      );
    }
    return InkWell(
      onTap: () => onStateChanged(state),
      borderRadius: radius,
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          width: kToolbarHeight * 3,
          height: kToolbarHeight,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Colors.blueGrey.withValues(alpha: 0.4),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: UiDimens.formRadius,
                  color: CCUtils.stateColor(state),
                ),
              ),
              Text(
                CCUtils.stateDisplay(state).toUpperCase(),
                style: const TextStyle(fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

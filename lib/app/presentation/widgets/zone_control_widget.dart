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
          width: 30,
          height: kToolbarHeight,
          margin: const EdgeInsets.only(right: 20),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: UiDimens.formRadius,
            color: Colors.blueGrey.withValues(alpha: 0.4),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: UiDimens.formRadius,
              color: CCUtils.stateColor(state),
            ),
          ),
        ),
        InkWell(
          onTap: () => onStateChanged(state),
          borderRadius: UiDimens.formRadius,
          child: Container(
            width: kToolbarHeight * 3,
            height: kToolbarHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: UiDimens.formRadius),
            child: Text(CCUtils.stateDisplay(state)),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

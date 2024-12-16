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
        // if (maxLevel >= 3)
        buildRow(context, HeaterState.level3),
        // if (maxLevel >= 2)
        buildRow(context, HeaterState.level2),
        buildRow(context, HeaterState.level1),
        buildRow(context, HeaterState.off),
      ],
    );
  }

  Widget buildRow(context, HeaterState state) {
    double height = 48;
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
          width: height * 2.4,
          height: height,
          decoration: BoxDecoration(
            borderRadius: radius,
            color: Colors.blueGrey
                .withValues(alpha: state == currentState ? 0.7 : 0.4),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: height,
                decoration: BoxDecoration(
                  color: CCUtils.stateColor(state),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  CCUtils.stateDisplay(state).toUpperCase(),
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

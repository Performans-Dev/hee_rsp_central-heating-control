import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/presentation/widgets/flame_indicator.dart';
import 'package:flutter/material.dart';

class ZoneCardModeDisplayWidget extends StatelessWidget {
  const ZoneCardModeDisplayWidget({
    super.key,
    required this.desiredState,
    required this.currentState,
    this.currentTemperature,
    this.desiredTemperature,
    this.planName,
  });
  final HeaterState desiredState;
  final int currentState;
  final int? currentTemperature;
  final int? desiredTemperature;
  final String? planName;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (desiredTemperature != null)
              Text(
                'Set: ${CCUtils.temperature(desiredTemperature!, presicion: 0)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            const SizedBox(height: 12),
            if (currentTemperature != null)
              Text(
                CCUtils.temperature(currentTemperature!),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    '${CCUtils.stateDisplay(desiredState)}${desiredState == HeaterState.auto ? ' ($planName)' : ''}'),
                const SizedBox(width: 8),
                FlameIndicatorWidget(value: currentState),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

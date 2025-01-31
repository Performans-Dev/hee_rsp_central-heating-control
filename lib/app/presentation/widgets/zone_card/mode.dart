import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/presentation/widgets/flame_indicator.dart';
import 'package:flutter/material.dart';

class ZoneCardModeDisplayWidget extends StatelessWidget {
  const ZoneCardModeDisplayWidget({
    super.key,
    required this.desiredMode,
    required this.currentMode,
    this.currentTemperature,
    this.desiredTemperature,
    this.planName,
  });
  final ControlMode desiredMode;
  final ControlMode currentMode;
  final double? currentTemperature;
  final double? desiredTemperature;
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
                'Set: ${desiredTemperature?.toStringAsFixed(1)} °C',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            const SizedBox(height: 12),
            if (currentTemperature != null)
              Text(
                '${currentTemperature?.toStringAsFixed(1)} °C',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                    '${CCUtils.stateDisplay(desiredMode)}${desiredMode == ControlMode.auto ? ' ($planName)' : ''}'),
                const SizedBox(width: 8),
                FlameIndicatorWidget(value: currentMode),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

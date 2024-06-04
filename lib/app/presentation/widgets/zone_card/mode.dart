import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/text.dart';
import 'package:central_heating_control/app/presentation/widgets/flame_indicator.dart';
import 'package:flutter/material.dart';

class ZoneCardModeDisplayWidget extends StatelessWidget {
  const ZoneCardModeDisplayWidget({
    super.key,
    required this.desiredState,
    required this.currentState,
    this.currentTemperature,
    this.desiredTemperature,
  });
  final HeaterState desiredState;
  final int currentState;
  final int? currentTemperature;
  final int? desiredTemperature;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (desiredTemperature != null)
              Text(
                'Set: ${TextUtils.temperature(desiredTemperature!)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            SizedBox(height: 12),
            if (currentTemperature != null)
              Text(
                TextUtils.temperature(currentTemperature!),
                style: Theme.of(context).textTheme.displaySmall,
              ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(TextUtils.stateDisplay(desiredState)),
                SizedBox(width: 8),
                FlameIndicatorWidget(value: currentState),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

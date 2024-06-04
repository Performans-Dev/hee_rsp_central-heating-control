import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/text.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/plan.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:flutter/material.dart';

class ZoneStateControlWidget extends StatelessWidget {
  const ZoneStateControlWidget({
    super.key,
    required this.zoneState,
    required this.stateCallback,
    this.planId,
    required this.planCallback,
    required this.hasThermostat,
    required this.onThermostatCallback,
    this.desiredTemperature,
  });
  final HeaterState zoneState;
  final Function(HeaterState) stateCallback;
  final int? planId;
  final Function(int?) planCallback;
  final bool hasThermostat;
  final Function(bool) onThermostatCallback;
  final int? desiredTemperature;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              ToggleButtons(
                children: [
                  Text('Off'),
                  Text('Auto'),
                  Text('On'),
                  Text('High'),
                  Text('Max'),
                ],
                isSelected: [
                  zoneState == HeaterState.off,
                  zoneState == HeaterState.auto,
                  zoneState == HeaterState.level1,
                  zoneState == HeaterState.level2,
                  zoneState == HeaterState.level3,
                ],
                borderRadius: UiDimens.formRadius,
                onPressed: (value) {
                  stateCallback(HeaterState.values[value]);
                },
              ),
            ],
          ),
          if (zoneState == HeaterState.auto)
            FormItemComponent(
              label: 'Selected Plan on Auto Mode',
              child: PlanDropdownWidget(
                onChanged: (v) => planCallback(v == -1 ? null : v),
                value: planId,
              ),
            ),
          if (zoneState == HeaterState.level1 ||
              zoneState == HeaterState.level2 ||
              zoneState == HeaterState.level3)
            FormItemComponent(
              label: 'Enable Thermostat',
              child: Row(
                children: [
                  Switch(value: hasThermostat, onChanged: onThermostatCallback),
                  if (hasThermostat && desiredTemperature != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
                        Text(TextUtils.temperature(desiredTemperature!,
                            presicion: 0)),
                        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      ],
                    ),
                ],
              ),
            ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

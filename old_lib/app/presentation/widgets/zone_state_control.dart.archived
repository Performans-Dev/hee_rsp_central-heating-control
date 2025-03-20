import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
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
    this.onMinusPressed,
    this.onPlusPressed,
  });
  final ControlMode zoneState;
  final Function(ControlMode) stateCallback;
  final int? planId;
  final Function(int?) planCallback;
  final bool hasThermostat;
  final Function(bool) onThermostatCallback;
  final int? desiredTemperature;
  final GestureTapCallback? onMinusPressed;
  final GestureTapCallback? onPlusPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      height: 110,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButtons(
                    isSelected: [
                      zoneState == ControlMode.off,
                      zoneState == ControlMode.auto,
                      zoneState == ControlMode.on,
                      zoneState == ControlMode.high,
                      zoneState == ControlMode.max,
                    ],
                    borderRadius: UiDimens.formRadius,
                    onPressed: (value) {
                      stateCallback(ControlMode.values[value]);
                    },
                    children: const [
                      Text('Off'),
                      Text('Auto'),
                      Text('On'),
                      Text('High'),
                      Text('Max'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 10,
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (zoneState == ControlMode.auto)
                    FormItemComponent(
                      label: 'Selected Plan on Auto Mode',
                      child: PlanDropdownWidget(
                        onChanged: (v) => planCallback(v == -1 ? null : v),
                        value: planId,
                      ),
                    ),
                  if (zoneState == ControlMode.on ||
                      zoneState == ControlMode.high ||
                      zoneState == ControlMode.max)
                    FormItemComponent(
                      label: 'Enable Thermostat',
                      child: Row(
                        children: [
                          Switch(
                              value: hasThermostat,
                              onChanged: onThermostatCallback),
                          if (hasThermostat && desiredTemperature != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: onMinusPressed,
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(
                                  CCUtils.temperature(desiredTemperature!,
                                      presicion: 0),
                                ),
                                IconButton(
                                  onPressed: onPlusPressed,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

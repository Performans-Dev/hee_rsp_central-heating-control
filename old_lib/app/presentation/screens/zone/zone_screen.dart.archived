// ignore_for_file: avoid_unnecessary_containers, unused_local_variable, prefer_const_constructors

import 'dart:math';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/plan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///
/// temperature-arrow-up
/// temperature-arrow-down
/// clock
/// calendar-days
/// power-off
///

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key, required this.zone});
  final Zone zone;

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  final DataController dataController = Get.find();
  final ChannelController channelController = Get.find();

  late Zone zone;
  Heater? selectedHeater;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      final List<Heater> heaters = dc.getHeatersOfZone(widget.zone.id);
      final List<SensorDeviceWithValues> sensors =
          dc.sensorListWithValues(widget.zone.id);
      final double sensorAverage = dc.getSensorAverageOfZone(widget.zone.id);
      int maxLevel = 1;
      for (final heater in heaters) {
        maxLevel = max(maxLevel, heater.levelType.index);
      }
      zone = dc.zoneList.firstWhere((e) => e.id == widget.zone.id);

      return AppScaffold(
        selectedIndex: 0,
        title: zone.name,
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Column(
                                    spacing: 8,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Zone Control ${zone.currentMode.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ControlModeWidget(
                                        selectedMode: zone.desiredMode,
                                        onChanged: (value) async {
                                          await dc.onZoneModeCalled(
                                              zoneId: zone.id, mode: value);
                                        },
                                        data: ControlMode.values,
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(20),
                                      child: ZoneDetailSubControlModeWidget(
                                        zone: zone,
                                        onThermostatChanged: (value) async {
                                          await dataController
                                              .onZoneThermostatCalled(
                                            zoneId: zone.id,
                                            hasThermostat: value,
                                          );
                                        },
                                        onPlanChanged: (value) async {
                                          await dataController.onZonePlanCalled(
                                            zoneId: zone.id,
                                            planId: value,
                                          );
                                        },
                                        onTemperatureChanged: (value) async {
                                          await dataController
                                              .onZoneTemperatureCalled(
                                            zoneId: zone.id,
                                            temperature: value,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: selectedHeater == null
                                  ? ZoneDetailHeaterListWidget(
                                      heaters: heaters,
                                      onHeaterSelected: (h) =>
                                          setState(() => selectedHeater = h),
                                      title: 'Heater(s) on ${zone.name}',
                                    )
                                  : ZoneDetailSelectedHeaterCardWidget(
                                      selectedHeater: selectedHeater!,
                                      onBack: () {
                                        setState(() {
                                          selectedHeater = null;
                                        });
                                      },
                                      onHeaterModeCalled:
                                          (ControlMode mode) async {
                                        await dataController.onHeaterModeCalled(
                                          heaterId: selectedHeater!.id,
                                          mode: mode,
                                        );
                                        setState(() {
                                          selectedHeater = null;
                                        });
                                      },
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              // MARK: SENSORS
              ZoneDetailSensorsWidget(
                  sensors: sensors, sensorAverage: sensorAverage),
            ],
          ),
        ),
      );
    });
  }
}

class ZoneDetailSubControlModeWidget extends StatelessWidget {
  const ZoneDetailSubControlModeWidget({
    super.key,
    required this.zone,
    required this.onPlanChanged,
    required this.onTemperatureChanged,
    required this.onThermostatChanged,
  });

  final Zone zone;
  final Function(int?) onPlanChanged;
  final Function(double) onTemperatureChanged;
  final Function(bool) onThermostatChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: zone.desiredMode == ControlMode.auto
          ? Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Plan for Automatic Controls',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                PlanDropdownWidget(
                  onChanged: onPlanChanged,
                  value: zone.selectedPlan,
                ),
              ],
            )
          : zone.desiredMode == ControlMode.off
              ? const Opacity(
                  opacity: 0.6,
                  child: Icon(
                    Icons.energy_savings_leaf_outlined,
                    size: 64,
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [
                    SwitchListTile(
                      value: zone.hasThermostat,
                      title: const Text('Thermostat'),
                      onChanged: (v) async => await onThermostatChanged(v),
                    ),
                    Opacity(
                      opacity: zone.hasThermostat ? 1 : 0.4,
                      child: Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: zone
                                    .hasThermostat //TODO: add minimum temperature check
                                ? () => onTemperatureChanged(
                                    (zone.desiredTemperature ?? 20) - 0.5)
                                : null,
                            icon: const Icon(Icons.remove),
                            iconSize: 38,
                          ),
                          Text(
                            '${zone.desiredTemperature ?? 20} °C',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          IconButton(
                            onPressed: zone
                                    .hasThermostat //TODO: add maximum temperature check
                                ? () => onTemperatureChanged(
                                    (zone.desiredTemperature ?? 20) + 0.5)
                                : null,
                            icon: const Icon(Icons.add),
                            iconSize: 38,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}

class ControlModeWidget extends StatelessWidget {
  const ControlModeWidget({
    super.key,
    required this.selectedMode,
    required this.onChanged,
    required this.data,
    this.isZone = true,
  });

  final ControlMode selectedMode;
  final Function(ControlMode p1) onChanged;
  final List<ControlMode> data;
  final bool isZone;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.vertical,
      constraints: const BoxConstraints(minWidth: 126, minHeight: 42),
      verticalDirection: VerticalDirection.up,
      borderRadius: UiDimens.formRadius,
      onPressed: (value) {
        onChanged(data[value]);
      },
      isSelected: data.map((e) => e == selectedMode).toList(),
      children: data
          .map((e) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: 126,
                height: 42,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CCUtils.stateIcon(e, withColor: selectedMode == e),
                    Text(e.name
                        .replaceAll('auto', !isZone ? 'Zone' : 'Auto')
                        .toUpperCase()),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class ZoneDetailSensorsWidget extends StatelessWidget {
  const ZoneDetailSensorsWidget({
    super.key,
    required this.sensors,
    required this.sensorAverage,
  });

  final List<SensorDeviceWithValues> sensors;
  final double sensorAverage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        spacing: 12,
        children: [
          Text(
            'Temperature: ',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          ...sensors.map((e) => Chip(
                label: Text(
                    'S${e.id}:  ${CCUtils.sensorRawToTemperature(e.value?.toInt())?.toStringAsFixed(1)} °C'),
              )),
          const Spacer(),
          Chip(
            label: Text(
                'Avg: ${CCUtils.sensorRawToTemperature(sensorAverage.toInt())?.toStringAsFixed(1)} °C'),
          ),
        ],
      ),
    );
  }
}

class ZoneDetailHeaterListWidget extends StatelessWidget {
  const ZoneDetailHeaterListWidget({
    super.key,
    required this.heaters,
    required this.onHeaterSelected,
    this.title = 'Heaters',
  });
  final String title;
  final List<Heater> heaters;
  final Function(Heater) onHeaterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        Text(title),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                  tileColor:
                      CommonUtils.hexToColor(context, heaters[index].color)
                          .withValues(alpha: 0.3),
                  shape:
                      RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
                  title: Text(heaters[index].name),
                  subtitle: Text(heaters[index].desiredMode.name),
                  onTap: () => onHeaterSelected(heaters[index])),
            ),
            itemCount: heaters.length,
          ),
        ),
      ],
    );
  }
}

class ZoneDetailSelectedHeaterCardWidget extends StatelessWidget {
  const ZoneDetailSelectedHeaterCardWidget({
    super.key,
    required this.selectedHeater,
    required this.onBack,
    required this.onHeaterModeCalled,
  });
  final Heater selectedHeater;
  final Function() onBack;
  final Function(ControlMode) onHeaterModeCalled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      spacing: 8,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              label: const Text(''),
            ),
            Text(selectedHeater.name),
          ],
        ),
        const Divider(),
        ControlModeWidget(
          selectedMode: selectedHeater.desiredMode,
          onChanged: onHeaterModeCalled,
          isZone: false,
          data: ControlMode.values,
        ),
      ],
    );
  }
}

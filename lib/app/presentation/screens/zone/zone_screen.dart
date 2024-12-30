// ignore_for_file: avoid_unnecessary_containers, unused_local_variable

import 'dart:math';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
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
                                        'Zone Control',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      ToggleButtons(
                                        direction: Axis.vertical,
                                        verticalDirection: VerticalDirection.up,
                                        borderRadius: UiDimens.formRadius,
                                        onPressed: (value) async {
                                          await dc.onZoneModeCalled(
                                            mode: ControlMode.values[value],
                                            zoneId: zone.id,
                                          );
                                        },
                                        isSelected: ControlMode.values
                                            .map((e) => e == zone.desiredMode)
                                            .toList(),
                                        children: ControlMode.values
                                            .map((e) => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  child: Row(
                                                    spacing: 8,
                                                    children: [
                                                      CCUtils.stateIcon(e),
                                                      Text(e.toString()),
                                                    ],
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                  const Expanded(
                                    child: Center(child: Text('sub')),
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
                              child: const Row(
                                children: [
                                  Text('Heaters / Heater'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*                     // MARK: Zone Controls
                      Expanded(
                        flex: 18,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Zone Controls',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Row(
                                children: [
                                  // ControlMode list
                                  ZoneDetailControlModeWidget(
                                      selectedMode: zone.desiredMode,
                                      onChanged: (value) async {
                                        await dc.onZoneModeCalled(
                                          mode: value,
                                          zoneId: zone.id,
                                        );
                                      }),
                                  // control mode detail
                                  ZoneDetailSubControlModeWidget(
                                    zone: zone,
                                    onPlanChanged: (value) async {
                                      await dc.onZonePlanCalled(
                                        zoneId: zone.id,
                                        planId: value,
                                      );
                                    },
                                    onTemperatureChanged: (value) async {
                                      await dc.onZoneTemperatureCalled(
                                        zoneId: zone.id,
                                        temperature: value,
                                      );
                                      setState(() {});
                                    },
                                    onThermostatChanged: (value) async {
                                      await dc.onZoneThermostatCalled(
                                        zoneId: zone.id,
                                        hasThermostat: value,
                                      );
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                      Expanded(
                        flex: 10,
                        child: Center(
                          child: selectedHeater == null
                              ? ZoneDetailHeaterListWidget(
                                  heaters: heaters,
                                  onHeaterSelected: (h) =>
                                      setState(() => selectedHeater = h),
                                )
                              : ZoneDetailSelectedHeaterCardWidget(
                                  selectedHeater: selectedHeater!,
                                  onBack: () {
                                    setState(() => selectedHeater = null);
                                  },
                                  onHeaterModeCalled: (ControlMode mode) async {
                                    await dc.onHeaterModeCalled(
                                      heaterId: selectedHeater!.id,
                                      mode: mode,
                                    );
                                    setState(() {});
                                  },
                                ),
                        ),
                      ),
                   
                    */
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
/* 
      return AppScaffold(
        selectedIndex: 0,
        title: zone.name,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            child: const Text('Zone Controls'),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: ZoneControlWidget(
                                      currentState: zone.currentMode,
                                      onStateChanged: (value) {
                                        dc.onZoneModeCalled(
                                          zoneId: zone.id,
                                          mode: value,
                                        );
                                      },
                                      maxLevel: maxLevel,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: UiDimens.formRadius,
                                    child: Container(
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: UiDimens.formRadius,
                                        color: Colors.blueGrey
                                            .withValues(alpha: 0.7),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 20,
                                            width: double.infinity,
                                            color: CCUtils.stateColor(
                                                zone.currentMode),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: zone.currentMode ==
                                                    ControlMode.auto
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          'Select Plan for AUTO'),
                                                      PlanDropdownWidget(
                                                        value:
                                                            zone.selectedPlan,
                                                        onChanged: (p0) {
                                                          final zd =
                                                              zone.copyWith(
                                                            selectedPlan: p0,
                                                          );
                                                          dc.updateZone(zd);
                                                          // TODO:
                                                          // processController
                                                          //     .initZone(zd);
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                : zone.currentMode !=
                                                        ControlMode.off
                                                    ? Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          SwitchListTile(
                                                              title: const Text(
                                                                  'Thermo'),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    UiDimens
                                                                        .formRadius,
                                                              ),
                                                              value: zone
                                                                  .hasThermostat,
                                                              onChanged: (p0) {
                                                                // TODO:
                                                                // processController
                                                                //     .onZoneThermostatOptionCalled(
                                                                //         zoneId: widget.zone
                                                                //             .id,
                                                                //         value:
                                                                //             p0);
                                                                // setState(() {});
                                                              }),
                                                          Opacity(
                                                            opacity:
                                                                zone.hasThermostat
                                                                    ? 1
                                                                    : 0.3,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .remove),
                                                                  iconSize: 36,
                                                                  onPressed:
                                                                      zone.hasThermostat
                                                                          ? () {
                                                                              // TODO:
                                                                              // processController.onZoneThermostatDecreased(zoneId: Zone!.id);
                                                                              // setState(() {});
                                                                            }
                                                                          : null,
                                                                ),
                                                                Text(
                                                                  ' ${(zone.desiredTemperature ?? 0).toStringAsPrecision(1)} °C ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          24),
                                                                ),
                                                                IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .add),
                                                                  iconSize: 36,
                                                                  onPressed:
                                                                      zone.hasThermostat
                                                                          ? () {
                                                                              // TODO:
                                                                              // processController.onZoneThermostatIncreased(zoneId: Zone!.id);
                                                                              // setState(() {});
                                                                            }
                                                                          : null,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .energy_savings_leaf,
                                                        size: 48,
                                                      ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.centerLeft,
                            child: selectedHeater == null
                                ? const Text('Heaters')
                                : TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        selectedHeater = null;
                                      });
                                    },
                                    icon: const Icon(Icons.chevron_left),
                                    label: const Text('Back to Heater List'),
                                  ),
                          ),
                          Expanded(
                            child: selectedHeater != null
                                ? Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: UiDimens.formRadius,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        spacing: 12,
                                        children: [
                                          Text(selectedHeater!.name),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ToggleButtons(
                                                borderRadius:
                                                    UiDimens.formRadius,
                                                isSelected: [
                                                  selectedHeater!.currentMode ==
                                                      ControlMode.auto,
                                                  selectedHeater!.currentMode !=
                                                      ControlMode.auto
                                                ],
                                                direction: Axis.vertical,
                                                onPressed: (index) {
                                                  dc.onHeaterModeCalled(
                                                    heaterId:
                                                        selectedHeater!.id,
                                                    mode: index == 0
                                                        ? ControlMode.auto
                                                        : ControlMode.off,
                                                  );
                                                  setState(() {});
                                                },
                                                children: const [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      spacing: 8,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                            Icons.auto_awesome),
                                                        Text('Zone'),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      spacing: 8,
                                                      children: [
                                                        Icon(Icons.settings),
                                                        Text('Custom'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              (selectedHeater!.currentMode ==
                                                      ControlMode.auto)
                                                  ? Container(width: 74)
                                                  : ToggleButtons(
                                                      borderRadius:
                                                          UiDimens.formRadius,
                                                      direction: Axis.vertical,
                                                      verticalDirection:
                                                          VerticalDirection.up,
                                                      isSelected: [
                                                        ...ControlMode.values
                                                            .where((e) =>
                                                                e !=
                                                                ControlMode
                                                                    .auto)
                                                            .map((e) =>
                                                                heaters
                                                                    .firstWhere((h) =>
                                                                        h.id ==
                                                                        selectedHeater
                                                                            ?.id)
                                                                    .currentMode ==
                                                                e),
                                                      ],
                                                      onPressed: (index) {
                                                        dc.onHeaterModeCalled(
                                                          heaterId:
                                                              selectedHeater!
                                                                  .id,
                                                          mode: ControlMode
                                                              .values
                                                              .where((e) =>
                                                                  e !=
                                                                  ControlMode
                                                                      .auto)
                                                              .toList()[index],
                                                        );
                                                        setState(() {});
                                                      },
                                                      children: [
                                                        ...ControlMode.values
                                                            .where((e) =>
                                                                e !=
                                                                ControlMode
                                                                    .auto)
                                                            .map((e) => e ==
                                                                    selectedHeater
                                                                        ?.currentMode
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Row(
                                                                      spacing:
                                                                          8,
                                                                      children: [
                                                                        const Icon(
                                                                            Icons.check),
                                                                        Text(CCUtils
                                                                            .stateDisplay(e))
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                        CCUtils.stateDisplay(
                                                                            e)),
                                                                  )),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemBuilder: (context, index) => ListTile(
                                      title: Text(heaters[index].name),
                                      leading: CircleAvatar(
                                        child: Text(
                                            '${heaters[index].currentMode}'),
                                      ),
                                      subtitle: Text(
                                        heaters[index]
                                            .currentMode
                                            .name
                                            .replaceAll('auto', 'zone')
                                            .toUpperCase(),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedHeater = heaters[index];
                                        });
                                      },
                                    ),
                                    itemCount: heaters.length,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (sensors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Chip(
                            label: Text(
                                'Sensor${sensors[index].id}: ${sensors[index].value == null ? '-' : sensors[index].value?.toStringAsPrecision(1)} °C'),
                          ),
                        ),
                        itemCount: sensors.length,
                      ),
                    ),
                    Chip(
                      label: Text(
                          'Avg: ${sensorAverage.toStringAsPrecision(1)} °C'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    */
    });
    /* 
    return GetBuilder<ProcessController>(builder: (pc) {
      zone =
          pc.zoneProcessList.firstWhere((e) => e.zone.id == Get.arguments[0]);
      heaters = pc.heaterProcessList
          .where((e) => e.heater.zoneId == Get.arguments[0])
          .toList();

      sensors = dataController.sensorList
          .where((e) => e.zone == Get.arguments[0])
          .toList();

      return AppScaffold(
        selectedIndex: 0,
        title: 'Zone View "${zone.zone.name}"',
        body: PiScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelWidget(text: 'Zone Controls'),
              ZoneStateControlWidget(
                zoneState: zone.selectedState,
                stateCallback: (v) {
                  Buzz.success();
                  pc.onZoneStateCalled(
                    zoneId: zone.zone.id,
                    state: v,
                  );
                },
                planId: zone.zone.selectedPlan,
                planCallback: (v) {
                  Buzz.success();
                  dataController.updateZonePlan(
                      zoneId: zone.zone.id, planId: v);
                },
                hasThermostat: zone.hasThermostat,
                onThermostatCallback: (b) {
                  Buzz.feedback();
                  pc.onZoneThermostatOptionCalled(
                      zoneId: zone.zone.id, value: b);
                },
                desiredTemperature: zone.desiredTemperature,
                onMinusPressed: zone.desiredTemperature > 150
                    ? () {
                        Buzz.mini();
                        pc.onZoneThermostatDecreased(zoneId: zone.zone.id);
                      }
                    : null,
                onPlusPressed: zone.desiredTemperature < 350
                    ? () {
                        Buzz.mini();
                        pc.onZoneThermostatIncreased(zoneId: zone.zone.id);
                      }
                    : null,
              ),
              const Divider(),
              const LabelWidget(text: 'Heaters'),
              ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    tileColor: CommonUtils.hexToColor(
                            context, heaters[index].heater.color)
                        .withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: UiDimens.formRadius),
                    title: Text(heaters[index].heater.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ToggleButtons(
                          borderRadius: UiDimens.formRadius,
                          onPressed: (v) {
                            Buzz.error();
                            //
                          },
                          isSelected: [
                            heaters[index].selectedState == HeaterState.off,
                            heaters[index].selectedState == HeaterState.auto,
                            heaters[index].selectedState == HeaterState.level1,
                            heaters[index].selectedState == HeaterState.level2,
                            heaters[index].selectedState == HeaterState.level3,
                          ],
                          children: const [
                            Text('Off'),
                            Text('Zone'),
                            Text('On'),
                            Text('High'),
                            Text('Max'),
                          ],
                        ),
                      ],
                    ),
                    leading: CircleAvatar(
                      child: Text(
                          CCUtils.stateDisplay(heaters[index].selectedState)),
                    ),
                    subtitle: Row(
                      children: [
                        Text('${heaters[index].currentLevel}'),
                      ],
                    ),
                  ),
                ),
                itemCount: heaters.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              const Divider(),
              const LabelWidget(text: 'Sensors'),
              ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(sensors[index].name ?? ""),
                  leading: CircleAvatar(
                    child: Text(
                      sensors[index].id.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                itemCount: sensors.length,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      );
    }); */
  }

  // Future<void> initZone(int zoneId) async {
  //   final zoneOnDb = await DbProvider.db.getZone(id: zoneId);
  //   if (zoneOnDb != null) {
  //     setState(() {
  //       Zone = zoneOnDb;
  //     });
  //     processController.initZone(Zone!);
  //   } else {
  //     Future.delayed(Duration.zero, () => Get.back());
  //   }
  // }
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Select Plan for Automatic Controls'),
                PlanDropdownWidget(
                  value: zone.selectedPlan,
                  onChanged: onPlanChanged,
                ),
              ],
            )
          : zone.desiredMode == ControlMode.off
              ? Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: const Icon(
                      Icons.energy_savings_leaf,
                      size: 48,
                    ),
                  ),
                )
              : Card(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SwitchListTile(
                          title: const Text('Thermostat'),
                          value: zone.hasThermostat,
                          onChanged: (b) {
                            onThermostatChanged(b);
                          },
                        ),
                        Opacity(
                          opacity: zone.hasThermostat &&
                                  zone.desiredTemperature != null
                              ? 1
                              : 0.4,
                          child: Row(
                            spacing: 8,
                            children: [
                              IconButton(
                                onPressed: zone.hasThermostat &&
                                        zone.desiredTemperature != null
                                    ? () {
                                        onTemperatureChanged(
                                            zone.desiredTemperature! - 1);
                                      }
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Text('${zone.desiredTemperature} °C'),
                              IconButton(
                                onPressed: zone.hasThermostat &&
                                        zone.desiredTemperature != null
                                    ? () {
                                        onTemperatureChanged(
                                            zone.desiredTemperature! + 1);
                                      }
                                    : null,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class ZoneDetailControlModeWidget extends StatelessWidget {
  const ZoneDetailControlModeWidget({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  final ControlMode selectedMode;
  final Function(ControlMode p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.vertical,
      constraints: const BoxConstraints(minWidth: 120, minHeight: 56),
      verticalDirection: VerticalDirection.up,
      onPressed: (value) {
        onChanged(ControlMode.values[value]);
      },
      isSelected: ControlMode.values.map((e) => e == selectedMode).toList(),
      children: ControlMode.values
          .map((e) => Row(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CCUtils.stateIcon(e, withColor: selectedMode == e),
                  Text(e.name.toUpperCase()),
                ],
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
                label: Text('S${e.id}:  ${e.value?.toStringAsPrecision(1)} °C'),
              )),
          const Spacer(),
          Chip(
            label: Text('Avg: ${sensorAverage.toStringAsPrecision(1)} °C'),
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
  });
  final List<Heater> heaters;
  final Function(Heater) onHeaterSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Heaters',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ...heaters.map((h) => ListTile(
                  title: Text(h.name),
                  subtitle: Text(h.currentMode.name),
                  onTap: () => onHeaterSelected(h),
                )),
          ],
        ),
      ),
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
    return Card(
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: onBack, icon: const Icon(Icons.arrow_back)),
                Text(
                  selectedHeater.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            ...ControlMode.values.map((e) => ListTile(
                  title: Text(e.name.replaceAll('auto', 'zone').toUpperCase()),
                  trailing: selectedHeater.desiredMode == e
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : null,
                  onTap: () {
                    onHeaterModeCalled(
                      e,
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}

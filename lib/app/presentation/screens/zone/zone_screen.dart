// ignore_for_file: avoid_unnecessary_containers, unused_local_variable

import 'dart:math';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  void initState() {
    super.initState();
    zone = widget.zone;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      final List<Heater> heaters = dc.getHeatersOfZone(zone.id);
      final List<SensorDeviceWithValues> sensors =
          dc.sensorListWithValues(zone.id);
      final double sensorAverage = dc.getSensorAverageOfZone(zone.id);
      int maxLevel = 1;
      for (final heater in heaters) {
        maxLevel = max(maxLevel, heater.levelType.index);
      }

      return AppScaffold(
        selectedIndex: 0,
        title: zone.name,
        body: Container(
          constraints: const BoxConstraints.expand(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Row(
                  children: [
                    // MARK: Zone Controls
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: const Text('Zone Controls'),
                      ),
                    ),

                    Expanded(
                      flex: 10,
                      child: Center(
                        child: selectedHeater == null
                            ?
                            // MARK: Heaters
                            Card(
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Heaters'),
                                      ...heaters.map((h) => ListTile(
                                          title: Text(h.name),
                                          subtitle: Text(h.currentMode.name),
                                          onTap: () {
                                            setState(() {
                                              selectedHeater = h;
                                            });
                                          })),
                                    ],
                                  ),
                                ),
                              )
                            :
                            // MARK: SELECTED HEATER
                            Card(
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() =>
                                                    selectedHeater = null);
                                              },
                                              icon:
                                                  const Icon(Icons.arrow_back)),
                                          Text(selectedHeater!.name),
                                          ...ControlMode.values
                                              .map((e) => ListTile(
                                                    title: Text(e.name
                                                        .replaceAll(
                                                            'auto', 'zone')
                                                        .toUpperCase()),
                                                  )),
                                        ],
                                      ),
                                      Container(
                                        child: Text(
                                            selectedHeater!.currentMode.name),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // MARK: SENSORS
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  spacing: 12,
                  children: [
                    const Text('Temperature: '),
                    ...sensors.map((e) => Chip(
                          label: Text(
                              'S${e.id}:  ${e.value?.toStringAsPrecision(1)} °C'),
                        )),
                    const Spacer(),
                    Chip(
                      label: Text(
                          'Avg: ${sensorAverage.toStringAsPrecision(1)} °C'),
                    ),
                  ],
                ),
              ),
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

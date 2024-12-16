import 'dart:math';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/data/models/process.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/plan.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_control_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key});

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  final ProcessController processController = Get.find();
  final DataController dataController = Get.find();
  final ChannelController channelController = Get.find();
  ZoneDefinition? zoneDefinition;
  late ZoneProcess zone;
  List<HeaterProcess> heaters = <HeaterProcess>[];
  late List<SensorDevice> sensors;
  HeaterProcess? selectedHeater;

  @override
  void initState() {
    super.initState();
    int zoneId = int.parse('${Get.arguments[0]}');
    initZone(zoneId);
  }

  @override
  Widget build(BuildContext context) {
    if (zoneDefinition != null) {
      zone = processController.zoneProcessList
          .firstWhere((e) => e.zone.id == zoneDefinition!.id);
      heaters = processController.heaterProcessList
          .where((e) => e.heater.zoneId == zoneDefinition!.id)
          .toList();
      sensors = dataController.sensorList
          .where((e) => e.zone == zoneDefinition!.id)
          .toList();
    }

    int maxLevel = 1;
    for (final heater in heaters) {
      maxLevel = max(maxLevel, heater.heater.levelType.index);
    }

    return AppScaffold(
      selectedIndex: 0,
      title: zone.zone.name,
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
                                    currentState: zone.selectedState,
                                    onStateChanged: (s) {
                                      processController.onZoneStateCalled(
                                        zoneId: zone.zone.id,
                                        state: s,
                                      );
                                      setState(() {});
                                    },
                                    maxLevel: maxLevel,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 160,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: UiDimens.formRadius,
                                    color:
                                        Colors.blueGrey.withValues(alpha: 0.7),
                                  ),
                                  child: zone.selectedState == HeaterState.auto
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text('Select Plan for AUTO'),
                                            PlanDropdownWidget(
                                              value:
                                                  zoneDefinition?.selectedPlan,
                                              onChanged: (p0) {
                                                if (zoneDefinition != null) {
                                                  final zd =
                                                      zoneDefinition!.copyWith(
                                                    selectedPlan: p0,
                                                  );
                                                  dataController.updateZone(zd);
                                                  processController
                                                      .initZone(zd);
                                                  setState(() {});
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      : zone.selectedState != HeaterState.off
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SwitchListTile(
                                                    title: const Text('Thermo'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          UiDimens.formRadius,
                                                    ),
                                                    value: zone.hasThermostat,
                                                    onChanged: (p0) {
                                                      processController
                                                          .onZoneThermostatOptionCalled(
                                                              zoneId:
                                                                  zoneDefinition!
                                                                      .id,
                                                              value: p0);
                                                      setState(() {});
                                                    }),
                                                Opacity(
                                                  opacity: zone.hasThermostat
                                                      ? 1
                                                      : 0.3,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.remove),
                                                        iconSize: 36,
                                                        onPressed: zone
                                                                .hasThermostat
                                                            ? () {
                                                                processController
                                                                    .onZoneThermostatDecreased(
                                                                        zoneId:
                                                                            zoneDefinition!.id);
                                                                setState(() {});
                                                              }
                                                            : null,
                                                      ),
                                                      Text(
                                                        ' ${(zone.desiredTemperature / 10).toInt()} °C ',
                                                        style: const TextStyle(
                                                            fontSize: 24),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.add),
                                                        iconSize: 36,
                                                        onPressed: zone
                                                                .hasThermostat
                                                            ? () {
                                                                processController
                                                                    .onZoneThermostatIncreased(
                                                                        zoneId:
                                                                            zoneDefinition!.id);
                                                                setState(() {});
                                                              }
                                                            : null,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const Icon(
                                              Icons.energy_savings_leaf,
                                              size: 48,
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
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedHeater = null;
                                    });
                                  },
                                  child: const Text('Back to Heater List'),
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
                                        Text(selectedHeater!.heater.name),
                                        ToggleButtons(
                                          borderRadius: UiDimens.formRadius,
                                          isSelected: [
                                            selectedHeater!.selectedState ==
                                                HeaterState.auto,
                                            selectedHeater!.selectedState !=
                                                HeaterState.auto
                                          ],
                                          onPressed: (index) {
                                            processController
                                                .onHeaterStateCalled(
                                              heaterId:
                                                  selectedHeater!.heater.id,
                                              state: index == 0
                                                  ? HeaterState.auto
                                                  : HeaterState.off,
                                            );
                                            setState(() {});
                                          },
                                          children: const [
                                            Text('Zone'),
                                            Text('Custom'),
                                          ],
                                        ),
                                        if (selectedHeater!.selectedState !=
                                            HeaterState.auto)
                                          ToggleButtons(
                                            borderRadius: UiDimens.formRadius,
                                            isSelected: [
                                              ...HeaterState.values
                                                  .where((e) =>
                                                      e != HeaterState.auto)
                                                  .map((e) =>
                                                      heaters
                                                          .firstWhere((h) =>
                                                              h.heater.id ==
                                                              selectedHeater
                                                                  ?.heater.id)
                                                          .selectedState ==
                                                      e),
                                            ],
                                            onPressed: (index) {
                                              processController
                                                  .onHeaterStateCalled(
                                                heaterId:
                                                    selectedHeater!.heater.id,
                                                state: HeaterState.values
                                                    .where((e) =>
                                                        e != HeaterState.auto)
                                                    .toList()[index],
                                              );
                                              setState(() {});
                                            },
                                            children: [
                                              ...HeaterState.values
                                                  .where((e) =>
                                                      e != HeaterState.auto)
                                                  .map((e) => Text(
                                                      CCUtils.stateDisplay(e))),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text(heaters[index].heater.name),
                                    subtitle:
                                        Text(heaters[index].heater.type.name),
                                    leading: CircleAvatar(
                                      child: Text(
                                          heaters[index].selectedState.name),
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
                    child:
                        //  ListView.builder(
                        //   itemBuilder: (context, index) => Padding(
                        //     padding: const EdgeInsets.only(right: 4),
                        //     child: Chip(
                        //       label: Text(
                        //           'Sensor${sensors[index].id}: ${channelController.getSensorValue(sensors[index].id)} °C'),
                        //     ),
                        //   ),
                        //   itemCount: sensors.length,
                        // ),
                        Text('${sensors.length} sensors'),
                  ),
                  const Chip(
                    label: Text('Avg: 23.4 °C'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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

  Future<void> initZone(int zoneId) async {
    final zoneOnDb = await DbProvider.db.getZone(id: zoneId);
    if (zoneOnDb != null) {
      setState(() {
        zoneDefinition = zoneOnDb;
      });
      processController.initZone(zoneDefinition!);
    } else {
      Future.delayed(Duration.zero, () => Get.back());
    }
  }
}

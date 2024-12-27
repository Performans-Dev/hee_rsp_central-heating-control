import 'dart:math';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/plan.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_control_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key, required this.zone});
  final Zone zone;

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  // final ProcessController processController = Get.find();
  // final DataController dataController = Get.find();
  // final ChannelController channelController = Get.find();
  // Zone? zone;
  // late ZoneProcess zone;
  // List<HeaterProcess> heaters = <HeaterProcess>[];
  // late List<SensorDevice> sensors;
  // HeaterProcess? selectedHeater;

  @override
  void initState() {
    super.initState();
    // int zoneId = int.parse('${Get.arguments[0]}');
    // initZone(zoneId);
  }

  @override
  Widget build(BuildContext context) {
    // if (Zone != null) {
    //   zone = processController.zoneProcessList
    //       .firstWhere((e) => e.zone.id == Zone!.id);
    //   heaters = processController.heaterProcessList
    //       .where((e) => e.heater.zoneId == Zone!.id)
    //       .toList();
    //   sensors =
    //       dataController.sensorList.where((e) => e.zone == Zone!.id).toList();
    // }

    // int maxLevel = 1;
    // for (final heater in heaters) {
    //   maxLevel = max(maxLevel, heater.heater.levelType.index);
    // }

    return GetBuilder<DataController>(builder: (dc) {
      final List<Heater> heaters = dc.getHeatersOfZone(widget.zone.id);
      // ignore: unused_local_variable
      final List<SensorDevice> sensors = dc.getSensorsOfZone(widget.zone.id);
      int maxLevel = 1;
      for (final heater in heaters) {
        maxLevel = max(maxLevel, heater.levelType.index);
      }

      return AppScaffold(
        selectedIndex: 0,
        title: '', //zone.zone.name,
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
                                      currentState: widget.zone.currentMode,
                                      onStateChanged: (s) {
                                        dc.onChangeZoneModePressed(
                                            widget.zone.id, s);
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
                                                widget.zone.currentMode),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: widget.zone.currentMode ==
                                                    ControlMode.auto
                                                ? Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Text(
                                                          'Select Plan for AUTO'),
                                                      PlanDropdownWidget(
                                                        value: widget
                                                            .zone.selectedPlan,
                                                        onChanged: (p0) {
                                                          final zd = widget.zone
                                                              .copyWith(
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
                                                : widget.zone.currentMode !=
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
                                                              value: widget.zone
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
                                                            opacity: widget.zone
                                                                    .hasThermostat
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
                                                                  onPressed: widget
                                                                          .zone
                                                                          .hasThermostat
                                                                      ? () {
                                                                          // TODO:
                                                                          // processController.onZoneThermostatDecreased(zoneId: Zone!.id);
                                                                          // setState(() {});
                                                                        }
                                                                      : null,
                                                                ),
                                                                Text(
                                                                  ' ${(widget.zone.desiredTemperature ?? 0).toStringAsPrecision(1)} °C ',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          24),
                                                                ),
                                                                IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .add),
                                                                  iconSize: 36,
                                                                  onPressed: widget
                                                                          .zone
                                                                          .hasThermostat
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
                        child: const Text("/TODO:")
                        // Column(
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //     Container(
                        //       padding: const EdgeInsets.all(8),
                        //       alignment: Alignment.centerLeft,
                        //       child: selectedHeater == null
                        //           ? const Text('Heaters')
                        //           : TextButton.icon(
                        //               onPressed: () {
                        //                 setState(() {
                        //                   selectedHeater = null;
                        //                 });
                        //               },
                        //               icon: const Icon(Icons.chevron_left),
                        //               label: const Text('Back to Heater List'),
                        //             ),
                        //     ),
                        //     Expanded(
                        //       child: selectedHeater != null
                        //           ? Card(
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: UiDimens.formRadius,
                        //               ),
                        //               child: Container(
                        //                 width: double.infinity,
                        //                 padding: const EdgeInsets.all(20),
                        //                 child: Column(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.center,
                        //                   spacing: 12,
                        //                   children: [
                        //                     Text(selectedHeater!.heater.name),
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.spaceEvenly,
                        //                       crossAxisAlignment:
                        //                           CrossAxisAlignment.start,
                        //                       children: [
                        //                         ToggleButtons(
                        //                           borderRadius:
                        //                               UiDimens.formRadius,
                        //                           isSelected: [
                        //                             selectedHeater!
                        //                                     .currentState ==
                        //                                 HeaterState.auto,
                        //                             selectedHeater!
                        //                                     .currentState !=
                        //                                 HeaterState.auto
                        //                           ],
                        //                           direction: Axis.vertical,
                        //                           onPressed: (index) {
                        //                             processController
                        //                                 .onHeaterStateCalled(
                        //                               heaterId: selectedHeater!
                        //                                   .heater.id,
                        //                               state: index == 0
                        //                                   ? HeaterState.auto
                        //                                   : HeaterState.off,
                        //                             );
                        //                             setState(() {});
                        //                           },
                        //                           children: const [
                        //                             Padding(
                        //                               padding:
                        //                                   EdgeInsets.all(8.0),
                        //                               child: Row(
                        //                                 spacing: 8,
                        //                                 mainAxisSize:
                        //                                     MainAxisSize.min,
                        //                                 children: [
                        //                                   Icon(
                        //                                       Icons.auto_awesome),
                        //                                   Text('Zone'),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                             Padding(
                        //                               padding:
                        //                                   EdgeInsets.all(8.0),
                        //                               child: Row(
                        //                                 spacing: 8,
                        //                                 children: [
                        //                                   Icon(Icons.settings),
                        //                                   Text('Custom'),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         (selectedHeater!.currentState ==
                        //                                 HeaterState.auto)
                        //                             ? Container(width: 74)
                        //                             : ToggleButtons(
                        //                                 borderRadius:
                        //                                     UiDimens.formRadius,
                        //                                 direction: Axis.vertical,
                        //                                 verticalDirection:
                        //                                     VerticalDirection.up,
                        //                                 isSelected: [
                        //                                   ...HeaterState.values
                        //                                       .where((e) =>
                        //                                           e !=
                        //                                           HeaterState
                        //                                               .auto)
                        //                                       .map((e) =>
                        //                                           heaters
                        //                                               .firstWhere((h) =>
                        //                                                   h.heater
                        //                                                       .id ==
                        //                                                   selectedHeater
                        //                                                       ?.heater
                        //                                                       .id)
                        //                                               .currentState ==
                        //                                           e),
                        //                                 ],
                        //                                 onPressed: (index) {
                        //                                   processController
                        //                                       .onHeaterStateCalled(
                        //                                     heaterId:
                        //                                         selectedHeater!
                        //                                             .heater.id,
                        //                                     state: HeaterState
                        //                                         .values
                        //                                         .where((e) =>
                        //                                             e !=
                        //                                             HeaterState
                        //                                                 .auto)
                        //                                         .toList()[index],
                        //                                   );
                        //                                   setState(() {});
                        //                                 },
                        //                                 children: [
                        //                                   ...HeaterState.values
                        //                                       .where((e) =>
                        //                                           e !=
                        //                                           HeaterState
                        //                                               .auto)
                        //                                       .map((e) => e ==
                        //                                               selectedHeater
                        //                                                   ?.currentState
                        //                                           ? Padding(
                        //                                               padding:
                        //                                                   const EdgeInsets
                        //                                                       .all(
                        //                                                       8.0),
                        //                                               child: Row(
                        //                                                 spacing:
                        //                                                     8,
                        //                                                 children: [
                        //                                                   const Icon(
                        //                                                       Icons.check),
                        //                                                   Text(CCUtils
                        //                                                       .stateDisplay(e))
                        //                                                 ],
                        //                                               ),
                        //                                             )
                        //                                           : Padding(
                        //                                               padding:
                        //                                                   const EdgeInsets
                        //                                                       .all(
                        //                                                       8.0),
                        //                                               child: Text(
                        //                                                   CCUtils.stateDisplay(
                        //                                                       e)),
                        //                                             )),
                        //                                 ],
                        //                               ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             )
                        //           : ListView.builder(
                        //               itemBuilder: (context, index) => ListTile(
                        //                 title: Text(heaters[index].heater.name),
                        //                 leading: CircleAvatar(
                        //                   child: Text(
                        //                       '${heaters[index].currentLevel}'),
                        //                 ),
                        //                 subtitle: Text(
                        //                   heaters[index]
                        //                       .currentState
                        //                       .name
                        //                       .replaceAll('auto', 'zone')
                        //                       .toUpperCase(),
                        //                 ),
                        //                 onTap: () {
                        //                   setState(() {
                        //                     selectedHeater = heaters[index];
                        //                   });
                        //                 },
                        //               ),
                        //               itemCount: heaters.length,
                        //             ),
                        //     ),
                        //   ],
                        // ),
                        ),
                  ),
                ],
              ),
            ),
            // if (sensors.isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child:
            //               //  ListView.builder(
            //               //   itemBuilder: (context, index) => Padding(
            //               //     padding: const EdgeInsets.only(right: 4),
            //               //     child: Chip(
            //               //       label: Text(
            //               //           'Sensor${sensors[index].id}: ${channelController.getSensorValue(sensors[index].id)} °C'),
            //               //     ),
            //               //   ),
            //               //   itemCount: sensors.length,
            //               // ),
            //               Text('${sensors.length} sensors'),
            //         ),
            //         const Chip(
            //           label: Text('Avg: 23.4 °C'),
            //         ),
            //       ],
            //     ),
            //   ),
          ],
        ),
      );
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

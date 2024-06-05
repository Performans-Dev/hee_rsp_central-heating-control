import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/process.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/plan.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/zone_state_control.dart';
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
  late ZoneProcess zone;
  List<HeaterProcess> heaters = <HeaterProcess>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProcessController>(builder: (pc) {
      zone =
          pc.zoneProcessList.firstWhere((e) => e.zone.id == Get.arguments[0]);
      heaters = pc.heaterProcessList
          .where((e) => e.heater.zoneId == Get.arguments[0])
          .toList();
      return AppScaffold(
        selectedIndex: 0,
        title: 'Zone View "${zone.zone.name}"',
        body: PiScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ZoneStateControlWidget(
                zoneState: zone.selectedState,
                stateCallback: (v) {
                  pc.onZoneStateCalled(
                    zoneId: zone.zone.id,
                    state: v,
                  );
                },
                planId: zone.zone.selectedPlan,
                planCallback: (v) {
                  dataController.updateZonePlan(
                      zoneId: zone.zone.id, planId: v);
                },
                hasThermostat: zone.hasThermostat,
                onThermostatCallback: (b) {
                  pc.onZoneThermostatOptionCalled(
                      zoneId: zone.zone.id, value: b);
                },
                desiredTemperature: zone.desiredTemperature,
                onMinusPressed: zone.desiredTemperature > 150
                    ? () {
                        pc.onZoneThermostatDecreased(zoneId: zone.zone.id);
                      }
                    : null,
                onPlusPressed: zone.desiredTemperature < 350
                    ? () {
                        pc.onZoneThermostatIncreased(zoneId: zone.zone.id);
                      }
                    : null,
              ),
              Divider(),
              Text('Heaters'),
              ListView.builder(
                itemBuilder: (context, index) =>
                    ListTile(title: Text(heaters[index].heater.name)),
                itemCount: heaters.length,
                shrinkWrap: true,
              ),
              Divider(),
              Text('Sensors'),
              /* 
               
                //MARK: WEEKLY PLAN
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: SwitchListTile(
                          value: planEnabled,
                          onChanged: (v) {
                            setState(() {
                              planEnabled = !planEnabled;
                            });
                          },
                          title: const Text('Enable Weekly Plan'),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (planEnabled)
                      Expanded(
                        child: PlanDropdownWidget(
                          onChanged: (value) {
                            setState(() {
                              selectedPlan = value;
                            });
                          },
                          value: selectedPlan,
                        ),
                      )
                  ],
                ),
                //MARK: HEATERS
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text('HEATERS'),
                ),
                heaters.isEmpty
                    ? const Center(
                        child: Text('No heater in zone'),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          final maxLevel = heaters[index].levelType.index;
                          var controlValues = <bool>[];
                          for (int i = 0; i <= maxLevel; i++) {
                            controlValues.add(false);
                          }
                          controlValues[heaters[index].state] = true;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: UiDimens.formRadius,
                              ),
                              tileColor: CommonUtils.hexToColor(
                                      context, heaters[index].color)
                                  .withOpacity(0.3),
                              title: Text(heaters[index].name),
                              subtitle: Text('state: ${heaters[index].state}'),
                              leading: heaters[index].icon.isEmpty
                                  ? null
                                  : Text(heaters[index].icon),
                              trailing: ToggleButtons(
                                isSelected: controlValues,
                                borderRadius: UiDimens.formRadius,
                                onPressed: (i) {
                                  //TODO:  print('Heater ${e.id} is now $i');
                                },
                                children: [
                                  for (int i = 0; i <= maxLevel; i++)
                                    Text(i.toString())
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: heaters.length,
                        shrinkWrap: true,
                      ),
        
                //MARK: SENSORS
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: const Text('SENSORS'),
                ),
                sensors.isEmpty
                    ? const Center(
                        child: Text('No sensors in zone'),
                      )
                    : Wrap(
                        children: sensors
                            .map((e) => Card(
                                  child: Column(
                                    children: [
                                      Text(e.name),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ), */
            ],
          ),
        ),
      );
    });
  }
}

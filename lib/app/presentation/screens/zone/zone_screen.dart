import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
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
              Text('Title: Zone Controls'),
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
              Text('Title Heaters'),
              ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    tileColor: CommonUtils.hexToColor(
                            context, heaters[index].heater.color)
                        .withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: UiDimens.formRadius),
                    title: Text(heaters[index].heater.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ToggleButtons(
                          borderRadius: UiDimens.formRadius,
                          onPressed: (v) {
                            //
                          },
                          children: [
                            Text('Off'),
                            Text('Zone'),
                            Text('On'),
                            Text('High'),
                            Text('Max'),
                          ],
                          isSelected: [
                            heaters[index].selectedState == HeaterState.off,
                            heaters[index].selectedState == HeaterState.auto,
                            heaters[index].selectedState == HeaterState.level1,
                            heaters[index].selectedState == HeaterState.level2,
                            heaters[index].selectedState == HeaterState.level3,
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
                physics: NeverScrollableScrollPhysics(),
              ),
              Divider(),
              Text('Title Sensors'),
              ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text('Sample Sensor'),
                  leading: CircleAvatar(
                    child: Text(
                      '22.3°',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                itemCount: 1,
                shrinkWrap: true,
              ),
            ],
          ),
        ),
      );
    });
  }
}

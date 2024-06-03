import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneScreen extends StatefulWidget {
  const ZoneScreen({super.key});

  @override
  State<ZoneScreen> createState() => _ZoneScreenState();
}

class _ZoneScreenState extends State<ZoneScreen> {
  late final ZoneDefinition zone;
  final DataController dataController = Get.find();
  List<HeaterDevice> heaters = <HeaterDevice>[];
  List<SensorDevice> sensors = <SensorDevice>[];

  @override
  void initState() {
    super.initState();
    zone = Get.arguments[0];
    heaters =
        dataController.heaterList.where((e) => e.zoneId == zone.id).toList();
    sensors =
        dataController.sensorList.where((e) => e.zoneId == zone.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 0,
      title: 'Zone View "${zone.name}"',
      body: Wrap(
        children: [
          ...heaters.map((e) {
            final maxLevel = e.levelType.index;
            var controlValues = <bool>[];
            for (int i = 0; i <= maxLevel; i++) {
              controlValues.add(false);
            }
            controlValues[e.state] = true;
            return Card(
              shape: RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      CommonUtils.hexToColor(context, e.color).withOpacity(0.3),
                  borderRadius: UiDimens.formRadius,
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(e.name),
                    ToggleButtons(
                      children: [
                        for (int i = 0; i <= maxLevel; i++) Text(i.toString())
                      ],
                      isSelected: controlValues,
                      borderRadius: UiDimens.formRadius,
                      onPressed: (i) {
                        print('Heater ${e.id} is now $i');
                      },
                    ),
                  ],
                ),
              ),
            );
          }),
          ...sensors.map((e) => Card(
                child: Column(
                  children: [
                    Text(e.name),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

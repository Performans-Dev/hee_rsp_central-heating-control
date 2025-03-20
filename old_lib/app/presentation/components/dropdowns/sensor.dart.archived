import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SensorDropdownWidget extends StatelessWidget {
  const SensorDropdownWidget({super.key, required this.channel});
  final ChannelDefinition channel;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      final sensor = dc.sensorList.firstWhereOrNull(
          (e) => e.device == channel.deviceId && e.index == channel.pinIndex);

      final zone = dc.zoneList.firstWhereOrNull((e) => e.id == sensor?.zone);

      return sensor == null
          ? Card(
              child: Center(
                child: Text(
                    'Sensor ${channel.name} not found\n\n${channel.deviceId} ${channel.pinIndex}'),
              ),
            )
          : Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(channel.name),
                  Text('${channel.deviceId} ${channel.pinIndex}'),
                  ZoneDropdownWidget(
                    value: zone,
                    onChanged: (value) {
                      final updatedSensor = sensor.copyWith(zone: value?.id);
                      dc.updateSensor(updatedSensor);
                    },
                  ),
                ],
              ),
            );
    });
  }
}

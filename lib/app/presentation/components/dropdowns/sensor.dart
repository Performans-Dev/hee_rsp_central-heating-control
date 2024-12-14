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
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(channel.name),
            Text('${channel.deviceId} ${channel.pinIndex}'),
            const ZoneDropdownWidget(
              value: null,
              onChanged: null,
            ),
          ],
        ),
      );
    });
  }
}

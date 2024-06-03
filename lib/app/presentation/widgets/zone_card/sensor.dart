import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:flutter/material.dart';

class ZoneCardSensorDisplayWidget extends StatelessWidget {
  const ZoneCardSensorDisplayWidget({
    super.key,
    required this.sensors,
  });
  final List<SensorDevice> sensors;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Text('22 °'),
    );
  }
}

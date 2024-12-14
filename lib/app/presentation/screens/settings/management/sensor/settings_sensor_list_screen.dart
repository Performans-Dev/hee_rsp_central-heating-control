import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/sensor.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSensorListScreen extends StatefulWidget {
  const SettingsSensorListScreen({super.key});

  @override
  State<SettingsSensorListScreen> createState() =>
      _SettingsSensorListScreenState();
}

class _SettingsSensorListScreenState extends State<SettingsSensorListScreen> {
  final DataController dc = Get.find();
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: "Sensors",
      body: GetBuilder<ChannelController>(
        builder: (cc) {
          final onboardAnalogInputs = cc.inputChannels
              .where((e) => e.type == PinType.onboardAnalogInput)
              .toList();
          final uartAnalogInputs = cc.inputChannels
              .where((e) => e.type == PinType.uartAnalogInput)
              .toList();
          final data = [...onboardAnalogInputs, ...uartAnalogInputs];

          return data.isEmpty
              ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    child: const Text('No sensors'),
                  ),
                )
              : Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: data
                      .map((e) => SensorDropdownWidget(channel: e))
                      .toList(),
                );
        },
      ),
    );
  }

  Widget sensorCard(
      SensorDevice sensorDevice, ValueChanged<String?> onZoneSelected) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sensorDevice.name ?? "Unknown Sensor",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: dc.getZoneListForDropdown().any((zone) =>
                      zone.id.toString() == sensorDevice.zone?.toString())
                  ? sensorDevice.zone?.toString()
                  : null,
              decoration: const InputDecoration(
                labelText: "Zone",
                border: OutlineInputBorder(),
              ),
              items: dc
                  .getZoneListForDropdown()
                  .map((zone) => DropdownMenuItem<String>(
                        value: zone.id.toString(),
                        child: Text(zone.name),
                      ))
                  .toList(),
              onChanged: onZoneSelected,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

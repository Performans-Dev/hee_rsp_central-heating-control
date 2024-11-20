import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';

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
      body: GetBuilder<DataController>(builder: (dc) {
        return dc.sensorList.isEmpty
            ? const Center(child: Text("No sensors found"))
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 12.0,
                  children: dc.sensorList
                      .map((sensor) => sensorCard(
                            sensor,
                            (value) {
                              if (value != null) {
                                sensor.zone = int.parse(value);
                                dc.updateSensor(sensor);
                              }
                            },
                          ))
                      .toList(),
                ),
              );
      }),
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

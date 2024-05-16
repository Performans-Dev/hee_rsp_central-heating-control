import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:get/get.dart'; // Bu import yolu kendi projenize göre güncellenmelidir.

class SensorSettingsScreen extends StatefulWidget {
  SensorSettingsScreen({Key? key}) : super(key: key);

  @override
  _SensorSettingsScreenState createState() => _SensorSettingsScreenState();
}

class _SensorSettingsScreenState extends State<SensorSettingsScreen> {
  final List<SensorDevice> sensorDevices = [];

  @override
  void initState() {
    super.initState();
    // initState içinde ilk kaydı ekleyebiliriz
  }

  Future<void> addInitialSensor() async {
    // İlk sensörü oluşturuyoruz
    final SensorDevice initialSensor = SensorDevice(
      id: 1,
      name: 'Initial Sensor',
      minValue: 0.0,
      maxValue: 100.0,
      comportId: 1,
      zoneId: 1,
    );

    await DbProvider.db.addSensor(initialSensor);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Sensor Settings",
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            // color: Theme.of(context).focusColor,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(20),
            child: Text(
              'Settings / Sensor Settings',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sensorDevices.length,
              itemBuilder: (_, index) {
                final SensorDevice sensorDevice = sensorDevices[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    dense: true,
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.toNamed(Routes.settingsEditSensor);
                            },
                            icon: const Icon(Icons.edit)),
                        const SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.delete)),
                      ],
                    ),
                    title: Text(sensorDevice.name),
                    subtitle: Text(
                      'Min Value: ${sensorDevice.minValue}, Max Value: ${sensorDevice.maxValue}',
                    ),
                  ),
                );
              },
            ),
          ),
          addSensorButon,
        ],
      ),
    );
  }

  Widget get addSensorButon => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(Routes.settingsAddSensor),
          child: const Text("Add New Sensor"),
        ),
      );
}

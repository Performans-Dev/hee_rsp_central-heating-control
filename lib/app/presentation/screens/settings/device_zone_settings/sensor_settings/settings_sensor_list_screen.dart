import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Bu import yolu kendi projenize göre güncellenmelidir.

class SettingsSensorListScreen extends StatefulWidget {
  const SettingsSensorListScreen({super.key});

  @override
  State<SettingsSensorListScreen> createState() =>
      _SettingsSensorListScreenState();
}

class _SettingsSensorListScreenState extends State<SettingsSensorListScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        title: "Sensors",
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              // color: Theme.of(context).focusColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              child: Text(
                'Settings / Sensors',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: dc.sensorList.isEmpty
                  ? Center(
                      child: Text('No sensor found'),
                    )
                  : ListView.builder(
                      itemCount: dc.sensorList.length,
                      itemBuilder: (_, index) {
                        final SensorDevice sensorDevice = dc.sensorList[index];
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
                                    onPressed: () {},
                                    icon: const Icon(Icons.delete)),
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
    });
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

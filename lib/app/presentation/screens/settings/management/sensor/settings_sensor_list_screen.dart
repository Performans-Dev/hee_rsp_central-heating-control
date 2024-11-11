import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
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

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const LabelWidget(
                    text: 'Settings / Sensors',
                  ),
                  addSensorButon,
                ],
              ),
            ),
            Expanded(
              child: dc.sensorList.isEmpty
                  ? const Center(
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
                                      Get.toNamed(Routes.settingsSensorEdit);
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
          ],
        ),
      );
    });
  }

  Widget get addSensorButon => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton.icon(
          onPressed: () => Get.toNamed(Routes.settingsSensorAdd),
          label: const Text("Add New Sensor"),
          icon: const Icon(Icons.add),
        ),
      );
}

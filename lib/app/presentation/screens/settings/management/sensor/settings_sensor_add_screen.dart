import 'package:central_heating_control/app/data/models/com_port.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/dropdown.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSensorAddScreen extends StatefulWidget {
  const SettingsSensorAddScreen({super.key});

  @override
  State<SettingsSensorAddScreen> createState() =>
      _SettingsSensorAddScreenState();
}

class _SettingsSensorAddScreenState extends State<SettingsSensorAddScreen> {
  final DataController dataController = Get.find();

  String? selectedSensorName;
  String? selectedColor;
  ZoneDefinition? selectedZone;
  ComPort? selectedSensor;

  List<String> sensorNames = ['Sensor A', 'Sensor B', 'Sensor C'];
  List<String> colorOptions = ['Red', 'Blue', 'Green'];

  @override
  void initState() {
    super.initState();

    dataController.getZoneListFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const LabelWidget(
                  text: 'Settings / Sensors / Add Sensor',
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      cancelButton,
                      const SizedBox(width: 12),
                      saveButton,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PiScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownWidget<String>(
                      data: sensorNames,
                      labelText: "Sensor Name",
                      hintText: "Select Name",
                      selectedValue: selectedSensorName,
                      onSelected: (value) {
                        setState(() {
                          selectedSensorName = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownWidget<String>(
                      data: colorOptions,
                      labelText: "Color",
                      hintText: "Select Color",
                      selectedValue: selectedColor,
                      onSelected: (value) {
                        setState(() {
                          selectedColor = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownWidget<ComPort>(
                      data: dc.comportList,
                      labelText: "Sensor",
                      hintText: "Select Sensor",
                      selectedValue: selectedSensor,
                      onSelected: (value) {
                        setState(() {
                          selectedSensor = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    DropdownWidget<ZoneDefinition>(
                      data: dc.zoneList,
                      labelText: "Zone",
                      hintText: "Select Zone",
                      selectedValue: selectedZone,
                      onSelected: (value) {
                        setState(() {
                          selectedZone = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget get saveButton => ElevatedButton(
        onPressed: () {},
        child: const Text("Save"),
      );

  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );
}

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsHeaterAddScreen extends StatefulWidget {
  const SettingsHeaterAddScreen({super.key});

  @override
  State<SettingsHeaterAddScreen> createState() =>
      _SettingsHeaterAddScreenState();
}

class _SettingsHeaterAddScreenState extends State<SettingsHeaterAddScreen> {
  HeaterDevice heater = HeaterDevice.initial();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController()
      ..addListener(() {
        setState(() {
          heater.name = nameController.text;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) => AppScaffold(
        title: 'Heaters',
        selectedIndex: 3,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name of the heater'),
              ),
              SizedBox(height: 20),
              ColorPickerWidget(
                onSelected: (v) => setState(() => heater.color = v),
                selectedValue: heater.color,
              ),
              SizedBox(height: 20),

              DropdownWidget(
                data: HeaterDeviceType.values,
                labelText: 'Heater Device Type',
                onSelected: (v) {
                  setState(() {
                    heater.type = v;
                  });
                },
                hintText: 'Select heater type',
                selectedValue: heater.type,
              ),
              DropdownWidget(
                data: HeaterDeviceConnectionType.values,
                labelText: 'Connection',
                hintText: 'Select connection type',
                selectedValue: heater.connectionType,
                onSelected: (v) {
                  setState(() {
                    heater.connectionType = v;
                  });
                },
              ),
              if (heater.connectionType == HeaterDeviceConnectionType.ethernet)
                TextField(
                  decoration: InputDecoration(labelText: 'Ip Address'),
                ),
              if (heater.connectionType == HeaterDeviceConnectionType.relay)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('level1 relay'),
                    Text('level1 consumption amount'),
                    Text('level1 consumption unit'),
                    Text('level2 relay'),
                    Text('level2 consumption amount'),
                    Text('level2 consumption unit'),
                    Text('error channel'),
                    Text('error channel type'),
                  ],
                ),
              DropdownWidget(
                data: dc.zoneList.map((e) => e.id).toList(),
                labelText: 'Zone',
                onSelected: (v) {
                  setState(() {
                    heater.zoneId = v;
                  });
                },
                hintText: 'select zone',
                selectedValue: heater.zoneId,
              ),

              //
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
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
        ),
      ),
    );
  }

  Widget get saveButton => ElevatedButton(
        onPressed: heater.name.isNotEmpty
            ? () async {
                final DataController dc = Get.find();
                final result = await dc.addHeater(heater);
                if (result) {
                  //TODO: snackbar success

                  Get.back();
                } else {
                  //TODO: snackbar error
                }
              }
            : null,
        child: const Text("Save"),
      );

  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );
}

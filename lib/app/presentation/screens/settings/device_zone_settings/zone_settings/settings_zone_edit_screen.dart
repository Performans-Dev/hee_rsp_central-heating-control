import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsZoneEditScreen extends StatefulWidget {
  const SettingsZoneEditScreen({super.key});

  @override
  State<SettingsZoneEditScreen> createState() => _SettingsZoneEditScreenState();
}

class _SettingsZoneEditScreenState extends State<SettingsZoneEditScreen> {
  final DataController dataController = Get.find();
  late ZoneDefinition zone;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    int id = int.parse(Get.parameters['id'] ?? '0');
    zone = dataController.zoneList.firstWhere((element) => element.id == id);
    nameController = TextEditingController(text: zone.name);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        title: 'Edit Zone',
        selectedIndex: 3,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Zone Name'),
              ),
              SizedBox(height: 20),
              Text('LABEL: Select Zone color'),
              ColorPickerWidget(
                onSelected: (v) => setState(() => zone.color = v),
                selectedValue: zone.color,
              ),
              SizedBox(height: 20),
              Text('LABEL: Select USers'),
            ],
          ),
        ),
      );
    });
  }
}

import 'dart:developer';

import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
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
    return GetBuilder<AppController>(builder: (app) {
      return GetBuilder<DataController>(builder: (dc) {
        return AppScaffold(
          title: 'Edit Zone',
          selectedIndex: 3,
          body: PiScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Zone Name'),
                ),
                const SizedBox(height: 20),
                const Text('LABEL: Select Zone color'),
                ColorPickerWidget(
                  onSelected: (v) => setState(() => zone.color = v),
                  selectedValue: zone.color,
                ),
                const SizedBox(height: 20),
                const Text('LABEL: Select USers'),
                for (final user in app.userList)
                  SwitchListTile(
                    title: Text(user.username),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: zone.users.map((e) => e.id).contains(user.id),
                    selected: zone.users.map((e) => e.id).contains(user.id),
                    onChanged: (value) => setState(() =>
                        //value ? zone.users.add(user) : zone.users.remove(user)
                        !zone.users.contains(user)
                            ? zone.users.add(user)
                            : zone.users.remove(user)),
                  ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      deleteButton,
                      Expanded(child: Container()),
                      cancelButton,
                      const SizedBox(width: 12),
                      saveButton,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }

  Widget get saveButton => ElevatedButton(
        onPressed: zone.users.isNotEmpty
            ? () async {
                final DataController dc = Get.find();
                final result = await dc.updateZone(zone);
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

  Widget get deleteButton => TextButton(
      onPressed: () {
        log('//TODO: confirm -> delete relations, delete record');
      },
      child: const Text(
        'Delete this zone and all of its contents',
        style: TextStyle(color: Colors.red),
      ));
}
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsZoneAddScreen extends StatefulWidget {
  const SettingsZoneAddScreen({super.key});

  @override
  State<SettingsZoneAddScreen> createState() => _SettingsZoneAddScreenState();
}

class _SettingsZoneAddScreenState extends State<SettingsZoneAddScreen> {
  ZoneDefinition zone = ZoneDefinition.initial();
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController()
      ..addListener(() {
        setState(() {
          zone.name = nameController.text;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Add New Zone',
        selectedIndex: 3,
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name of the zone'),
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
                  onChanged: (value) => setState(() =>
                      value ? zone.users.add(user) : zone.users.remove(user)),
                ),

              //
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    cancelButton,
                    const SizedBox(width: 12),
                    saveButton,
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget get saveButton => ElevatedButton(
        onPressed: zone.users.isNotEmpty
            ? () async {
                final DataController dc = Get.find();
                final result = await dc.addZone(zone);
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

import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
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
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name of the zone'),
              ),
              SizedBox(height: 20),
              Text('LABEL: Select Zone color'),
              SizedBox(
                height: 120,
                width: double.infinity,
                child: Wrap(
                  children: UiData.colorList
                      .map((e) => Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                setState(() {
                                  zone.color = e;
                                });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: CommonUtils.hexToColor(e)
                                      .withOpacity(0.3),
                                  padding: EdgeInsets.all(20),
                                  child: Icon(zone.color == e
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              Text('LABEL: Select USers'),
              for (final user in app.userList)
                SwitchListTile(
                  title: Text(user.username),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: zone.users.map((e) => e.id).contains(user.id),
                  onChanged: (value) {
                    if (value) {
                      setState(() {
                        zone.users.add(user);
                      });
                    } else {
                      setState(() {
                        zone.users.remove(user);
                      });
                    }
                  },
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

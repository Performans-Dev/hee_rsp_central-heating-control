import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

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
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: UiDimens.formBorder,
                  labelText: 'Name of the zone',
                ),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    label: 'Zone Name',
                    initialValue: nameController.text,
                    maxLength: 16,
                    minLength: 1,
                    type: OSKInputType.name,
                  );
                  if (result != null) {
                    setState(() {
                      nameController.text = result;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text('LABEL: Select Zone color'),
              ColorPickerWidget(
                onSelected: (v) => setState(() => zone.color = v),
                selectedValue: zone.color,
              ),

              const SizedBox(height: 20),
              const Text('LABEL: Select Users'),
              for (final user in app.userList)
                SwitchListTile(
                  title: Text(user.username),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: user.isAdmin
                      ? true
                      : zone.users.map((e) => e.id).contains(user.id),
                  onChanged: user.isAdmin
                      ? null
                      : (value) => setState(() => value
                          ? zone.users.add(user)
                          : zone.users.remove(user)),
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
        onPressed: zone.name.isNotEmpty ? saveZone : null,
        child: const Text("Save"),
      );

  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );

  void saveZone() async {
    final DataController dc = Get.find();
    final result = await dc.addZone(zone);
    if (result) {
      if (mounted) {
        DialogUtils.snackbar(
          context: context,
          message: 'Zone added',
          type: SnackbarType.success,
        );
      }
      Get.back();
    } else {
      if (mounted) {
        DialogUtils.snackbar(
          context: context,
          message: 'Unexpected error occured',
          type: SnackbarType.error,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: saveZone,
          ),
        );
      }
    }
  }
}

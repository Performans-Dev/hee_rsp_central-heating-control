import 'dart:developer';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/zone.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/zone/widget/select_user.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsZoneEditScreen extends StatefulWidget {
  const SettingsZoneEditScreen({super.key});

  @override
  State<SettingsZoneEditScreen> createState() => _SettingsZoneEditScreenState();
}

class _SettingsZoneEditScreenState extends State<SettingsZoneEditScreen> {
  final DataController dataController = Get.find();
  late Zone zone;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    int id = int.parse(Get.parameters['id'] ?? '0');
    nameController = TextEditingController();
    zone = dataController.zoneList.firstWhere((element) => element.id == id);
    nameController.text = zone.name;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return GetBuilder<DataController>(builder: (dc) {
        return AppScaffold(
          title: 'Edit Zone',
          selectedIndex: 3,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        labelText: 'Zone Name',
                      ),
                      onTap: () async {
                        final result = await OnScreenKeyboard.show(
                          context: context,
                          initialValue: nameController.text,
                          label: 'Zone Name',
                          hintText: 'Type a zone name here',
                          maxLength: 16,
                          minLength: 1,
                          type: OSKInputType.name,
                        );
                        if (result != null) {
                          nameController.text = result;
                        }
                        setState(() {
                          zone = zone.copyWith(name: nameController.text);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const LabelWidget(text: 'Select Zone color'),
                    ColorPickerWidget(
                      onSelected: (v) =>
                          setState(() => zone = zone.copyWith(color: v)),
                      selectedValue: zone.color,
                    ),
                    const SizedBox(height: 20),
                    const LabelWidget(text: 'Select Users'),
                    MultiSelectUserWidget(
                      onSelected: (p0) {
                        setState(() {
                          zone = zone.copyWith(users: p0);
                        });
                      },
                      selectedUsers: zone.users,
                      users: app.appUserList
                          .where((e) => e.level == AppUserLevel.user)
                          .toList(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                color: Colors.transparent,
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
        );
      });
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

  Widget get deleteButton => TextButton(
      onPressed: () async {
        await DbProvider.db.deleteZone(zone);
        await dataController.loadZoneList();
        await dataController.loadHeaterList();
      },
      child: const Text(
        'Delete this zone and all of its contents',
        style: TextStyle(color: Colors.red),
      ));

  Future<void> saveZone() async {
    final DataController dc = Get.find();
    final result = await dc.updateZone(zone);
    if (result) {
      if (mounted) {
        DialogUtils.snackbar(
          context: context,
          message: 'Zone Updated',
          type: SnackbarType.success,
        );
      }

      Get.back();
    } else {
      if (mounted) {
        DialogUtils.snackbar(
          context: context,
          message: 'Couldn\'t update zone',
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

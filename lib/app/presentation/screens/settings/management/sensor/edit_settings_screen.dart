import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/models/sensor_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsSensorEditScreen extends StatefulWidget {
  SettingsSensorEditScreen({super.key});

  @override
  State<SettingsSensorEditScreen> createState() =>
      _SettingsSensorEditScreenState();
}

class _SettingsSensorEditScreenState extends State<SettingsSensorEditScreen> {
  final DataController dataController = Get.find();

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Edit Sensor",
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: PiScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: UiDimens.formBorder,
                      labelText: 'Sensor Name',
                    ),
                    onTap: () async {
                      final result = await OnScreenKeyboard.show(
                        context: context,
                        initialValue: nameController.text,
                        label: 'Sensor Name',
                        hintText: 'Type a sensor name here',
                        maxLength: 16,
                        minLength: 1,
                        type: OSKInputType.name,
                      );
                      if (result != null) {
                        nameController.text = result;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 50,
            color: Colors.transparent,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [cancelButton, const SizedBox(width: 12), saveButton],
            ),
          )
        ],
      ),
    );
  }

  Widget get saveButton => ElevatedButton(
        onPressed: () {
          //onSaveButonPressed
        },
        child: const Text("Save"),
      );

  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );
}

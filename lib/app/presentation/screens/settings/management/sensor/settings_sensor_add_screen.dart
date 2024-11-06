import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/models/com_port.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/dropdown.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsSensorAddScreen extends StatefulWidget {
  const SettingsSensorAddScreen({super.key});

  @override
  State<SettingsSensorAddScreen> createState() =>
      _SettingsSensorAddScreenState();
}

class _SettingsSensorAddScreenState extends State<SettingsSensorAddScreen> {
  final DataController dataController = Get.find();
  late TextEditingController nameController;
  String? selectedSensorName;
  String? selectedColor;
  ZoneDefinition? selectedZone;
  ComPort? selectedSensor;

  List<String> sensorNames = ['Sensor A', 'Sensor B', 'Sensor C'];
  List<String> colorOptions = ['Red', 'Blue', 'Green'];

  @override
  void initState() {
    super.initState();

    dataController.getSensorListFromDb();

    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LabelWidget(
                  text: 'Settings / Sensors / Add Sensor',
                ),
              ],
            ),
            Expanded(
              child: PiScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    FormItemComponent(
                      label: 'Name',
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          border: UiDimens.formBorder,
                        ),
                        onTap: () async {
                          final result = await OnScreenKeyboard.show(
                            context: context,
                            initialValue: nameController.text,
                            label: 'Heater Name',
                            hintText: 'Type a name for your heater',
                            maxLength: 16,
                            minLength: 1,
                            type: OSKInputType.name,
                          );
                          if (result != null) {
                            nameController.text = result;
                            setState(() {});
                          }
                        },
                      ),
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
                    FormItemComponent(
                      label: 'Display Color',
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            color: Theme.of(context)
                                .inputDecorationTheme
                                .border
                                ?.borderSide
                                .color,
                            borderRadius: UiDimens.formRadius),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(4),
                        child: ColorPickerWidget(
                          onSelected: (v) => setState(() => selectedColor = v),
                          selectedValue: selectedColor,
                        ),
                      ),
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
                children: [
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

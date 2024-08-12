import 'package:central_heating_control/app/data/models/com_port.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
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
  late final TextEditingController nameController;
  late final TextEditingController minValueController;
  late final TextEditingController maxValueController;
  ZoneDefinition? selectedZone;
  ComPort? selectedPort;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    minValueController = TextEditingController();
    maxValueController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    minValueController.dispose();
    maxValueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      return AppScaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              // color: Theme.of(context).focusColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              child: Text(
                'Settings / Sensors / Add Sensor',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: PiScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextInputWidget(
                      keyboardType: TextInputType.name,
                      labelText: 'Name',
                    ),
                    const TextInputWidget(
                      keyboardType: TextInputType.number,
                      labelText: 'MinValue',
                    ),
                    const TextInputWidget(
                      keyboardType: TextInputType.number,
                      labelText: 'MaxValue',
                    ),
                    // DropdownWidget<ComPort?>(
                    //   data: dc.comportList,
                    //   labelText: "Comport",
                    //   hintText: "Select Comport",
                    //   onSelected: (p0) {
                    //     setState(() {
                    //       selectedPort = p0;
                    //     });
                    //   },
                    //   selectedValue: selectedPort,
                    // ),
                    // const SizedBox(height: 8),
                    // DropdownWidget<ZoneDefinition?>(
                    //   hintText: "Select Zone",
                    //   data: dc.zoneList,
                    //   labelText: "Zone",
                    //   onSelected: (p0) {
                    //     setState(() {
                    //       selectedZone = p0;
                    //     });
                    //   },
                    //   selectedValue: selectedZone,
                    // ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          cancelButton,
                          const SizedBox(width: 12),
                          saveButton
                        ],
                      ),
                    )
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

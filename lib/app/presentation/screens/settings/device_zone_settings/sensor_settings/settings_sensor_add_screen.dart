import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  int? selectedZone;
  String? selectedPort;

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'Name',
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'MinValue',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'MaxValue',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton<String?>(
                        underline: Container(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        isExpanded: true,
                        value: selectedPort,
                        items: dc.comportList
                            .map((e) => DropdownMenuItem<String>(
                                  child: Text(e.title),
                                  value: e.id,
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPort = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: dc.zoneList.isEmpty
                          ? Text('No zone available')
                          : DropdownButton<int?>(
                              underline: Container(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              isExpanded: true,
                              value: selectedZone,
                              items: dc.zoneList
                                  .map((e) => DropdownMenuItem<int>(
                                        child: Text(e.name),
                                        value: e.id,
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedZone = value;
                                });
                              },
                            ),
                    ),
                    SizedBox(
                      height: 200,
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [cancelButton, const SizedBox(width: 12), saveButton],
              ),
            )
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

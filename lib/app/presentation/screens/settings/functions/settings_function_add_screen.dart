import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/function.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsFunctionAddScreen extends StatefulWidget {
  const SettingsFunctionAddScreen({super.key});

  @override
  State<SettingsFunctionAddScreen> createState() =>
      _SettingsFunctionAddScreenState();
}

class _SettingsFunctionAddScreenState extends State<SettingsFunctionAddScreen> {
  final DataController dataController = Get.find();
  int? fromHour;
  int? toHour;
  int? zoneId;
  int? heaterId;
  ControlMode? controlMode;
  String name = '';
  late TextEditingController nameController;
  bool hasHours = false;

  @override
  initState() {
    super.initState();
    nameController = TextEditingController(text: name);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: 'Add Function',
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextInputWidget(
                          labelText: 'Function Name',
                          controller: nameController,
                          keyboardType: TextInputType.name,
                        ),
                        CheckboxListTile(
                          value: hasHours,
                          onChanged: (v) {
                            setState(() => hasHours = v ?? false);
                          },
                          title: const Text('Has Start-Stop Hours'),
                        ),
                        if (hasHours)
                          RangeSlider(
                            values: RangeValues((fromHour ?? 8).toDouble(),
                                (toHour ?? 17).toDouble()),
                            onChanged: (RangeValues values) {
                              setState(() {
                                fromHour = values.start.toInt();
                                toHour = values.end.toInt();
                              });
                            },
                            min: 0,
                            max: 24,
                            divisions: 24,
                            labels: RangeLabels(fromHour?.toString() ?? '8',
                                toHour?.toString() ?? '17'),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ZoneDropdownWidget(
                          onChanged: (z) {
                            setState(() => zoneId = z?.id);
                          },
                        ),
                        // HeaterDropdownWidget(onChanged: (h) {
                        //   setState(() {
                        //     heaterId = h?.id;
                        //   });
                        // }),
                        ToggleButtons(
                          isSelected: ControlMode.values
                              .map((e) => controlMode == e)
                              .toList(),
                          onPressed: (index) => setState(
                              () => controlMode = ControlMode.values[index]),
                          borderRadius: UiDimens.formRadius,
                          children: ControlMode.values
                              .map((e) => Text(e.name))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  label: const Text('Cancel'),
                  icon: const Icon(Icons.cancel),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final FunctionDefinition fd = FunctionDefinition(
                      id: 0,
                      name: name,
                      controlMode: controlMode,
                      zoneId: zoneId,
                      fromHour: fromHour,
                      toHour: toHour,
                      heaterId: heaterId,
                    );
                    final result = await DbProvider.db.addFunction(fd);
                    if (result > 0) {
                      await dataController.loadFunctionList();
                      Get.back();
                    } else {
                      //TODO: print error
                    }
                  },
                  label: const Text('Save'),
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

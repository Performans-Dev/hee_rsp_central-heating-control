import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/channel.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/connection_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/error_channel_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/level_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsDeviceEditScreen extends StatefulWidget {
  const SettingsDeviceEditScreen({super.key});

  @override
  State<SettingsDeviceEditScreen> createState() =>
      _SettingsDeviceEditScreenState();
}

class _SettingsDeviceEditScreenState extends State<SettingsDeviceEditScreen> {
  late HeaterDevice heater;
  final DataController dataController = Get.find();
  late TextEditingController nameController;
  late TextEditingController l1ConsumptionController;
  late TextEditingController l2ConsumptionController;
  late TextEditingController l3ConsumptionController;
  late TextEditingController l1UnitController;
  late TextEditingController l2UnitController;
  late TextEditingController l3UnitController;
  late TextEditingController l1CarbonController;
  late TextEditingController l2CarbonController;
  late TextEditingController l3CarbonController;
  late TextEditingController ipAddressController;

  @override
  void initState() {
    super.initState();
    int id = int.parse(Get.parameters['id'] ?? '0');
    if (id > 0) {
      heater =
          dataController.heaterList.firstWhere((element) => element.id == id);
    } else {
      NavController.toHome();
    }
    nameController = TextEditingController(text: heater.name);
    l1ConsumptionController = TextEditingController(
        text: (heater.level1ConsumptionAmount ?? 0).toString());
    l2ConsumptionController = TextEditingController(
        text: (heater.level2ConsumptionAmount ?? 0).toString());
    l3ConsumptionController = TextEditingController(
        text: (heater.level3ConsumptionAmount ?? 0).toString());
    // l1UnitController =
    //     TextEditingController(text: heater.level1ConsumptionUnit ?? '');
    // l2UnitController =
    //     TextEditingController(text: heater.level2ConsumptionUnit ?? '');
    // l3UnitController =
    //     TextEditingController(text: heater.level3ConsumptionUnit ?? '');
    l1CarbonController =
        TextEditingController(text: (heater.level1Carbon ?? 0).toString());
    l2CarbonController =
        TextEditingController(text: (heater.level2Carbon ?? 0).toString());
    l3CarbonController =
        TextEditingController(text: (heater.level3Carbon ?? 0).toString());
    ipAddressController =
        TextEditingController(text: heater.ipAddress ?? '0.0.0.0');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) => AppScaffold(
        title: 'Edit Heater',
        selectedIndex: 3,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //MARK: NAME
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
                              setState(() {
                                heater.name = result;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          //MARK: TYPE-CONNECTION-ZONE

                          //#region TYPE
                          Expanded(
                            child: FormItemComponent(
                              label: 'Type',
                              child: TypeDropdownWidget(
                                onChanged: (value) {
                                  setState(() {
                                    heater.type =
                                        value ?? HeaterDeviceType.none;
                                  });
                                },
                                value: heater.type,
                              ),
                            ),
                          ),
                          //#endregion
                          const SizedBox(width: 8),

                          //#region CONNECTION
                          Expanded(
                            child: FormItemComponent(
                              label: 'Connection',
                              child: ConnectionTypeDropdownWidget(
                                showNoneOption: false,
                                onChanged: (value) {
                                  setState(() {
                                    heater.connectionType = value ??
                                        HeaterDeviceConnectionType.none;
                                  });
                                },
                                value: heater.connectionType,
                              ),
                            ),
                          ),
                          //#endregion
                          const SizedBox(width: 8),
                          //#region ZONE
                          Expanded(
                            child: FormItemComponent(
                              label: 'Zone',
                              child: ZoneDropdownWidget(
                                onChanged: (value) {
                                  setState(() {
                                    heater.zoneId = value?.id;
                                  });
                                },
                                value: dc.zoneList.firstWhereOrNull(
                                    (e) => e.id == heater.zoneId),
                              ),
                            ),
                          ),
                          //#endregion
                          const SizedBox(width: 8),

                          //#region LEVEL

                          Expanded(
                            child: FormItemComponent(
                              label: 'Level',
                              child: LevelTypeDropdownWidget(
                                showNoneOption: false,
                                value: heater.levelType,
                                onChanged: (value) {
                                  setState(() {
                                    heater.levelType = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                          //#endregion
                        ],
                      ),
                      const SizedBox(height: 12),

                      //MARK: IP
                      if (heater.connectionType ==
                          HeaterDeviceConnectionType.ethernet)
                        //#region IP ADDRESS
                        FormItemComponent(
                          label: 'Ip Addres',
                          child: TextInputWidget(
                            controller: ipAddressController,
                            labelText: "Ip Address",
                          ),
                        ),
                      //#endregion
                      //MARK: RELAY
                      if (heater.connectionType ==
                          HeaterDeviceConnectionType.relay)
                        heater.levelType == HeaterDeviceLevel.onOff
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [level1, errorChanel],
                              )
                            : heater.levelType == HeaterDeviceLevel.twoLevels
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [level1, level2, errorChanel],
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      level1,
                                      level2,
                                      level3,
                                      errorChanel
                                    ],
                                  ),
                      const SizedBox(height: 12),

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
                            onSelected: (v) => setState(() => heater.color = v),
                            selectedValue: heater.color,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
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
  }

  Widget get level1 => Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(color: Colors.orange),
            /* FormItemComponent(
              label: 'Level 1 Relay',
              child: ChannelDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    heater.outputChannel1 =
                        (value?.id ?? '').isEmpty ? null : value;
                  });
                },
                value: heater.outputChannel1,
                group: GpioGroup.outPin,
              ),
            ), */
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: FormItemComponent(
              label: 'Consumption',
              child: TextField(
                controller: l1ConsumptionController,
                decoration: InputDecoration(
                  border: UiDimens.formBorder,
                ),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: l1ConsumptionController.text,
                    label: 'Consumption',
                    type: OSKInputType.number,
                  );
                  if (result != null) {
                    l1ConsumptionController.text = result;
                    setState(() {
                      heater.level1ConsumptionAmount = double.tryParse(result);
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: FormItemComponent(
              label: 'Unit',
              child: TextField(
                controller: l1UnitController,
                decoration: InputDecoration(
                  border: UiDimens.formBorder,
                ),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: l1UnitController.text,
                    label: 'Unit',
                    type: OSKInputType.text,
                  );
                  if (result != null) {
                    l1UnitController.text = result;
                    setState(() {
                      // heater.level1ConsumptionUnit = result;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      );

  Widget get level2 => Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(color: Colors.orange),
            /* FormItemComponent(
              label: 'Level 2 Relay',
              child: ChannelDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    heater.level2Relay =
                        (value?.id ?? '').isEmpty ? null : value;
                  });
                },
                value: heater.level2Relay,
                group: GpioGroup.outPin,
              ),
            ), */
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: FormItemComponent(
              label: 'Consumption',
              child: TextField(
                controller: l2ConsumptionController,
                decoration: InputDecoration(border: UiDimens.formBorder),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: l2ConsumptionController.text,
                    label: 'Consumption',
                    type: OSKInputType.number,
                  );
                  if (result != null) {
                    l2ConsumptionController.text = result;
                    setState(() {
                      heater.level2ConsumptionAmount = double.tryParse(result);
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: FormItemComponent(
              label: 'Unit',
              child: TextField(
                controller: l2UnitController,
                decoration: InputDecoration(border: UiDimens.formBorder),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: l2UnitController.text,
                    label: 'Unit',
                    type: OSKInputType.text,
                  );
                  if (result != null) {
                    l2UnitController.text = result;
                    setState(() {
                      // heater.level2ConsumptionUnit = result;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      );
  Widget get level3 => Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(color: Colors.orange),
            /*  FormItemComponent(
              label: 'Level 3 Relay',
              child: ChannelDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    heater.level3Relay =
                        (value?.id ?? '').isEmpty ? null : value;
                  });
                },
                value: heater.level3Relay,
                group: GpioGroup.outPin,
              ),
            ), */
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: FormItemComponent(
              label: 'Consumption',
              child: TextField(
                controller: l3ConsumptionController,
                decoration: InputDecoration(border: UiDimens.formBorder),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: l3ConsumptionController.text,
                    label: 'Consumption',
                    type: OSKInputType.number,
                  );
                  if (result != null) {
                    l3ConsumptionController.text = result;
                    setState(() {
                      heater.level3ConsumptionAmount = double.tryParse(result);
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: FormItemComponent(
              label: 'Unit',
              child: TextField(
                controller: l3UnitController,
                decoration: InputDecoration(border: UiDimens.formBorder),
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: l3UnitController.text,
                    label: 'Unit',
                    type: OSKInputType.text,
                  );
                  if (result != null) {
                    l3UnitController.text = result;
                    setState(() {
                      // heater.level3ConsumptionUnit = result;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      );
  Widget get errorChanel => Row(
        children: [
          Expanded(
            flex: 5,
            child: Container(color: Colors.orange),
            /* FormItemComponent(
                label: 'Error Channel',
                child: ChannelDropdownWidget(
                  onChanged: (value) {
                    setState(() {
                      heater.errorChannel =
                          (value?.id ?? '').isEmpty ? null : value;
                    });
                  },
                  value: heater.errorChannel,
                  group: GpioGroup.inPin,
                )), */
          ),
          Expanded(
            flex: 3,
            child: FormItemComponent(
              label: 'Error Channel Type',
              child: ErrorChannelTypeDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    heater.errorChannelType = value;
                  });
                },
                value: heater.errorChannelType ?? ErrorChannelType.nO,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      );
  Widget get saveButton => ElevatedButton(
        onPressed: heater.name.isNotEmpty &&
                heater.type != HeaterDeviceType.none &&
                heater.connectionType != HeaterDeviceConnectionType.none
            ? () async {
                final result = await dataController.updateHeater(heater);
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

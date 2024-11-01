import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/channel.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/connection_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/error_channel_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
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
    l1UnitController =
        TextEditingController(text: heater.level1ConsumptionUnit ?? '');
    l2UnitController =
        TextEditingController(text: heater.level2ConsumptionUnit ?? '');
    l3UnitController =
        TextEditingController(text: heater.level3ConsumptionUnit ?? '');
    l1CarbonController =
        TextEditingController(text: (heater.level1Carbon ?? 0).toString());
    l2CarbonController =
        TextEditingController(text: (heater.level2Carbon ?? 0).toString());
    l3CarbonController =
        TextEditingController(text: (heater.level3Carbon ?? 0).toString());
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
                                  heater.type = value ?? HeaterDeviceType.none;
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
                              onChanged: (value) {
                                setState(() {
                                  heater.connectionType =
                                      value ?? HeaterDeviceConnectionType.none;
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
                      ],
                    ),
                    const SizedBox(height: 12),

                    //MARK: IP
                    if (heater.connectionType ==
                        HeaterDeviceConnectionType.ethernet)
                      //#region IP ADDRESS
                      FormItemComponent(
                        label: 'Ip Addres',
                        child: Text('${heater.ipAddress}'),
                      ),
                    //#endregion
                    //MARK: RELAY
                    if (heater.connectionType ==
                        HeaterDeviceConnectionType.relay)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: FormItemComponent(
                                  label: 'Level 1 Relay',
                                  child: ChannelDropdownWidget(
                                    onChanged: (value) {
                                      setState(() {
                                        heater.level1Relay =
                                            (value?.id ?? '').isEmpty
                                                ? null
                                                : value;
                                      });
                                    },
                                    value: heater.level1Relay,
                                    group: GpioGroup.outPin,
                                  ),
                                ),
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
                                      final result =
                                          await OnScreenKeyboard.show(
                                        context: context,
                                        initialValue:
                                            l1ConsumptionController.text,
                                        label: 'Consumption',
                                        type: OSKInputType.number,
                                      );
                                      if (result != null) {
                                        l1ConsumptionController.text = result;
                                        setState(() {
                                          heater.level1ConsumptionAmount =
                                              double.tryParse(result);
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
                                      final result =
                                          await OnScreenKeyboard.show(
                                        context: context,
                                        initialValue: l1UnitController.text,
                                        label: 'Unit',
                                        type: OSKInputType.text,
                                      );
                                      if (result != null) {
                                        l1UnitController.text = result;
                                        setState(() {
                                          heater.level1ConsumptionUnit = result;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: FormItemComponent(
                                  label: 'Level 2 Relay',
                                  child: ChannelDropdownWidget(
                                    onChanged: (value) {
                                      setState(() {
                                        heater.level2Relay =
                                            (value?.id ?? '').isEmpty
                                                ? null
                                                : value;
                                      });
                                    },
                                    value: heater.level2Relay,
                                    group: GpioGroup.outPin,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 3,
                                child: FormItemComponent(
                                  label: 'Consumption',
                                  child: TextField(
                                    controller: l2ConsumptionController,
                                    decoration: InputDecoration(
                                        border: UiDimens.formBorder),
                                    onTap: () async {
                                      final result =
                                          await OnScreenKeyboard.show(
                                        context: context,
                                        initialValue:
                                            l2ConsumptionController.text,
                                        label: 'Consumption',
                                        type: OSKInputType.number,
                                      );
                                      if (result != null) {
                                        l2ConsumptionController.text = result;
                                        setState(() {
                                          heater.level2ConsumptionAmount =
                                              double.tryParse(result);
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
                                    decoration: InputDecoration(
                                        border: UiDimens.formBorder),
                                    onTap: () async {
                                      final result =
                                          await OnScreenKeyboard.show(
                                        context: context,
                                        initialValue: l2UnitController.text,
                                        label: 'Unit',
                                        type: OSKInputType.text,
                                      );
                                      if (result != null) {
                                        l2UnitController.text = result;
                                        setState(() {
                                          heater.level2ConsumptionUnit = result;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: FormItemComponent(
                                    label: 'Error Channel',
                                    child: ChannelDropdownWidget(
                                      onChanged: (value) {
                                        setState(() {
                                          heater.errorChannel =
                                              (value?.id ?? '').isEmpty
                                                  ? null
                                                  : value;
                                        });
                                      },
                                      value: heater.errorChannel,
                                      group: GpioGroup.inPin,
                                    )),
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
                                    value: heater.errorChannelType ??
                                        ErrorChannelType.nO,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                            ],
                          ),
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

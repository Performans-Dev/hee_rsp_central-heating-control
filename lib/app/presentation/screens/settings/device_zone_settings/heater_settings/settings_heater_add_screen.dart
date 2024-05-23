import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/comport.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/connection_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/error_channel_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SettingsHeaterAddScreen extends StatefulWidget {
  const SettingsHeaterAddScreen({super.key});

  @override
  State<SettingsHeaterAddScreen> createState() =>
      _SettingsHeaterAddScreenState();
}

class _SettingsHeaterAddScreenState extends State<SettingsHeaterAddScreen> {
  HeaterDevice heater = HeaterDevice.initial();
  late TextEditingController nameController;
  late TextEditingController ipAddressController;
  late TextEditingController level1ConsumptionController;
  late TextEditingController level1UnitController;
  late TextEditingController level2ConsumptionController;
  late TextEditingController level2UnitController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController()
      ..addListener(() => setState(() => heater.name = nameController.text));
    ipAddressController = TextEditingController()
      ..addListener(
          () => setState(() => heater.ipAddress = ipAddressController.text));
    level1ConsumptionController = TextEditingController()
      ..addListener(() => setState(() => heater.level1ConsumptionAmount =
          double.tryParse(level1ConsumptionController.text)));
    level1UnitController = TextEditingController()
      ..addListener(() => setState(
          () => heater.level1ConsumptionUnit = level1UnitController.text));
    level2ConsumptionController = TextEditingController()
      ..addListener(() => setState(() => heater.level2ConsumptionAmount =
          double.tryParse(level2ConsumptionController.text)));
    level2UnitController = TextEditingController()
      ..addListener(() => setState(
          () => heater.level2ConsumptionUnit = level2UnitController.text));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) => AppScaffold(
        title: 'Heaters',
        selectedIndex: 3,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //#region NAME
              FormItemComponent(
                label: 'Name',
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(border: UiDimens.formBorder),
                ),
              ),
              //#endregion

              Row(
                children: [
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
                        value: dc.zoneList
                            .firstWhereOrNull((e) => e.id == heater.zoneId),
                      ),
                    ),
                  ),
                  //#endregion
                ],
              ),

              if (heater.connectionType == HeaterDeviceConnectionType.ethernet)
                //#region IP ADDRESS
                FormItemComponent(
                  label: 'Ip Addres',
                  child: TextField(
                    controller: ipAddressController,
                    decoration: InputDecoration(border: UiDimens.formBorder),
                  ),
                ),
              //#endregion
              if (heater.connectionType == HeaterDeviceConnectionType.relay)
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
                            child: ComPortDropdownWidget(
                              onChanged: (value) {
                                setState(() {
                                  heater.level1Relay =
                                      (value?.id ?? '').isEmpty ? null : value;
                                });
                              },
                              value: heater.level1Relay,
                              group: GpioGroup.outPin,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: FormItemComponent(
                            label: 'Consumption',
                            child: TextField(
                              enabled: heater.level1Relay != null,
                              controller: level1ConsumptionController,
                              decoration:
                                  InputDecoration(border: UiDimens.formBorder),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: FormItemComponent(
                            label: 'Unit',
                            child: TextField(
                              enabled: heater.level1Relay != null,
                              controller: level1UnitController,
                              decoration:
                                  InputDecoration(border: UiDimens.formBorder),
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
                            child: ComPortDropdownWidget(
                              onChanged: (value) {
                                setState(() {
                                  heater.level2Relay =
                                      (value?.id ?? '').isEmpty ? null : value;
                                });
                              },
                              value: heater.level2Relay,
                              group: GpioGroup.outPin,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: FormItemComponent(
                            label: 'Consumption',
                            child: TextField(
                              enabled: heater.level2Relay != null,
                              controller: level2ConsumptionController,
                              decoration:
                                  InputDecoration(border: UiDimens.formBorder),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: FormItemComponent(
                            label: 'Unit',
                            child: TextField(
                              enabled: heater.level2Relay != null,
                              controller: level2UnitController,
                              decoration:
                                  InputDecoration(border: UiDimens.formBorder),
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
                              child: ComPortDropdownWidget(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get saveButton => ElevatedButton(
        onPressed: heater.name.isNotEmpty &&
                heater.type != HeaterDeviceType.none &&
                heater.connectionType != HeaterDeviceConnectionType.none
            ? () async {
                final DataController dc = Get.find();
                final result = await dc.addHeater(heater);
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

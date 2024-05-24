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
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsHeaterEditScreen extends StatefulWidget {
  const SettingsHeaterEditScreen({super.key});

  @override
  State<SettingsHeaterEditScreen> createState() =>
      _SettingsHeaterEditScreenState();
}

class _SettingsHeaterEditScreenState extends State<SettingsHeaterEditScreen> {
  late HeaterDevice heater;
  final DataController dataController = Get.find();

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
              FormItemComponent(label: 'Name', child: Text(heater.name)),
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
                  child: Text('${heater.ipAddress}'),
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
                            child: ChannelDropdownWidget(
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
                            child: Text('${heater.level1ConsumptionAmount}'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: FormItemComponent(
                            label: 'Unit',
                            child: Text('${heater.level1ConsumptionUnit}'),
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
                            child: Text('${heater.level2ConsumptionAmount}'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          flex: 1,
                          child: FormItemComponent(
                            label: 'Unit',
                            child: Text('${heater.level2ConsumptionUnit}'),
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

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
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
import 'package:central_heating_control/app/presentation/widgets/action_button.dart';
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
  late Heater heater;
  final DataController dataController = Get.find();
  late TextEditingController nameController;
  late TextEditingController l1ConsumptionController;
  late TextEditingController l2ConsumptionController;
  late TextEditingController l3ConsumptionController;
  late TextEditingController unitController;
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
    unitController = TextEditingController(text: heater.consumptionUnit ?? '');
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
      builder: (dc) {
        final viewName = FormItemComponent(
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
                setState(() => heater = heater.copyWith(name: result));
              }
            },
          ),
        );

        final viewColor = FormItemComponent(
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
              onSelected: (v) =>
                  setState(() => heater = heater.copyWith(color: v)),
              selectedValue: heater.color,
            ),
          ),
        );

        final viewHeaterType = Expanded(
          child: FormItemComponent(
            label: 'Type',
            child: TypeDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater =
                      heater.copyWith(type: value ?? HeaterDeviceType.none);
                });
              },
              value: heater.type,
            ),
          ),
        );

        final viewConnectionType = Expanded(
          child: FormItemComponent(
            label: 'Connection',
            child: ConnectionTypeDropdownWidget(
              showNoneOption: false,
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(
                      connectionType: value ?? HeaterDeviceConnectionType.none);
                });
              },
              value: heater.connectionType,
            ),
          ),
        );

        final viewZone = Expanded(
          child: FormItemComponent(
            label: 'Zone',
            child: ZoneDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(zoneId: value?.id);
                });
              },
              value: dc.zoneList.firstWhereOrNull((e) => e.id == heater.zoneId),
            ),
          ),
        );

        final viewLevel = Expanded(
          child: FormItemComponent(
            label: 'Level',
            child: LevelTypeDropdownWidget(
              showNoneOption: false,
              value: heater.levelType,
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(levelType: value!);
                });
              },
            ),
          ),
        );

        final viewIpAddress = FormItemComponent(
          label: 'Ip Addres',
          child: TextInputWidget(
            controller: ipAddressController,
            labelText: "Ip Address",
          ),
        );

        final viewLevel1Channel = Expanded(
          child: FormItemComponent(
            label: 'Level 1 Channel',
            child: ChannelDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(outputChannel1: value);
                });
              },
              value: heater.outputChannel1,
              group: GpioGroup.outPin,
            ),
          ),
        );

        final viewLevel2Channel = Expanded(
          child: FormItemComponent(
            label: 'Level 2 Channel',
            child: ChannelDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(outputChannel2: value);
                });
              },
              value: heater.outputChannel2,
              group: GpioGroup.outPin,
            ),
          ),
        );

        final viewLevel3Channel = Expanded(
          child: FormItemComponent(
            label: 'Level 3 Channel',
            child: ChannelDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(outputChannel3: value);
                });
              },
              value: heater.outputChannel3,
              group: GpioGroup.outPin,
            ),
          ),
        );

        final viewErrorChannel = Expanded(
          child: FormItemComponent(
            label: 'Error Channel',
            child: ChannelDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(errorChannel: value);
                });
              },
              value: heater.errorChannel,
              group: GpioGroup.inPin,
            ),
          ),
        );

        final viewErrorType = Expanded(
          child: FormItemComponent(
            label: 'Error Channel Type',
            child: ErrorChannelTypeDropdownWidget(
              onChanged: (value) {
                setState(() {
                  heater = heater.copyWith(errorChannelType: value);
                });
              },
              value: heater.errorChannelType ?? ErrorChannelType.nO,
            ),
          ),
        );

        final viewLevel1Consumption = Expanded(
          child: FormItemComponent(
            label: 'Consumption L1',
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
                    heater = heater.copyWith(
                        level1ConsumptionAmount: double.tryParse(result));
                  });
                }
              },
            ),
          ),
        );

        final viewLevel2Consumption = Expanded(
          child: FormItemComponent(
            label: 'Consumption L2',
            child: TextField(
              controller: l2ConsumptionController,
              decoration: InputDecoration(
                border: UiDimens.formBorder,
              ),
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
                    heater = heater.copyWith(
                        level2ConsumptionAmount: double.tryParse(result));
                  });
                }
              },
            ),
          ),
        );

        final viewLevel3Consumption = Expanded(
          child: FormItemComponent(
            label: 'Consumption L3',
            child: TextField(
              controller: l3ConsumptionController,
              decoration: InputDecoration(
                border: UiDimens.formBorder,
              ),
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
                    heater = heater.copyWith(
                        level3ConsumptionAmount: double.tryParse(result));
                  });
                }
              },
            ),
          ),
        );

        final viewUnit = Expanded(
          child: FormItemComponent(
            label: 'Unit',
            child: TextField(
              controller: unitController,
              decoration: InputDecoration(
                border: UiDimens.formBorder,
              ),
              onTap: () async {
                final result = await OnScreenKeyboard.show(
                  context: context,
                  initialValue: unitController.text,
                  label: 'Unit',
                  type: OSKInputType.text,
                );
                if (result != null) {
                  unitController.text = result;
                  setState(() {
                    heater = heater.copyWith(consumptionUnit: result);
                  });
                }
              },
            ),
          ),
        );

        final viewChannels = Row(
          spacing: 8,
          children: [
            ...(heater.levelType == HeaterDeviceLevel.onOff
                ? [
                    viewLevel1Channel,
                    viewErrorChannel,
                    viewErrorType,
                  ]
                : heater.levelType == HeaterDeviceLevel.twoLevels
                    ? [
                        viewLevel1Channel,
                        viewLevel2Channel,
                        viewErrorChannel,
                        viewErrorType,
                      ]
                    : [
                        viewLevel1Channel,
                        viewLevel2Channel,
                        viewLevel3Channel,
                        viewErrorChannel,
                        viewErrorType,
                      ]),
          ],
        );

        final viewConsumptions = Row(
          spacing: 8,
          children: [
            ...(heater.levelType == HeaterDeviceLevel.onOff
                ? [viewLevel1Consumption]
                : heater.levelType == HeaterDeviceLevel.twoLevels
                    ? [
                        viewLevel1Consumption,
                        viewLevel2Consumption,
                      ]
                    : [
                        viewLevel1Consumption,
                        viewLevel2Consumption,
                        viewLevel3Consumption,
                      ]),
            viewUnit,
          ],
        );

        return AppScaffold(
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
                        viewName,
                        viewColor,
                        Row(
                          spacing: 8,
                          children: [
                            viewHeaterType,
                            viewConnectionType,
                          ],
                        ),
                        Row(
                          spacing: 8,
                          children: [
                            viewZone,
                            viewLevel,
                          ],
                        ),
                        heater.connectionType ==
                                HeaterDeviceConnectionType.relay
                            ? viewChannels
                            : viewIpAddress,
                        viewConsumptions,
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 12,
                children: [
                  cancelButton,
                  saveButton,
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget get saveButton => ActionButton(
        labelText: 'Save'.tr,
        onPressed: heater.name.isNotEmpty &&
                heater.type != HeaterDeviceType.none &&
                heater.connectionType != HeaterDeviceConnectionType.none
            ? () async {
                final result = await dataController.updateHeater(heater);
                if (result) {
                  if (mounted) {
                    DialogUtils.snackbar(
                      context: context,
                      message: 'Changes saved',
                      type: SnackbarType.success,
                    );
                  }
                  Get.back();
                } else {
                  if (mounted) {
                    DialogUtils.snackbar(
                      context: context,
                      message: 'Could not save changes',
                      type: SnackbarType.error,
                    );
                  }
                }
              }
            : null,
        suffixIcon: const Icon(Icons.check),
      );

  Widget get cancelButton => ActionButton(
        labelText: 'Cancel'.tr,
        onPressed: () => Get.back(),
        prefixIcon: const Icon(Icons.chevron_left),
      );
}

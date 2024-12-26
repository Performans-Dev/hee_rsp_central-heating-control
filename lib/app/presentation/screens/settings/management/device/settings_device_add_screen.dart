// ignore_for_file: avoid_print, unused_local_variable

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/heater.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/channel.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/connection_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/error_channel_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/level_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/wizard_page_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsDeviceAddScreen extends StatefulWidget {
  const SettingsDeviceAddScreen({super.key});

  @override
  State<SettingsDeviceAddScreen> createState() =>
      _SettingsDeviceAddScreenState();
}

class _SettingsDeviceAddScreenState extends State<SettingsDeviceAddScreen> {
  Heater heater = Heater.initial();
  late PageController pageController;
  int currentPage = 0;
  late TextEditingController nameController;
  late TextEditingController ipAddressController;
  // late TextEditingController level1ConsumptionController;
  // late TextEditingController level1UnitController;
  // late TextEditingController level1CarbonController;
  // late TextEditingController level2ConsumptionController;
  // late TextEditingController level2UnitController;
  // late TextEditingController level2CarbonController;
  // late TextEditingController level3ConsumptionController;
  // late TextEditingController level3UnitController;
  // late TextEditingController level3CarbonController;

  @override
  void initState() {
    super.initState();
    pageController = PageController()
      ..addListener(() {
        setState(() {
          currentPage = pageController.hasClients
              ? (pageController.page?.toInt() ?? 0)
              : 0;
        });
      });
    nameController = TextEditingController()
      ..addListener(() => setState(() => heater = heater.copyWith(name: nameController.text)));
    // ipAddressController = TextEditingController()
    //   ..addListener(
    //       () => setState(() => heater.ipAddress = ipAddressController.text));
    // level1ConsumptionController = TextEditingController()
    //   ..addListener(() => setState(() => heater.level1ConsumptionAmount =
    //       double.tryParse(level1ConsumptionController.text)));
    // level1UnitController = TextEditingController()
    //   ..addListener(() => setState(
    //       () => heater.level1ConsumptionUnit = level1UnitController.text));
    // level1CarbonController = TextEditingController()
    //   ..addListener(() => setState(() =>
    //       heater.level1Carbon = double.tryParse(level1CarbonController.text)));
    // level2ConsumptionController = TextEditingController()
    //   ..addListener(() => setState(() => heater.level2ConsumptionAmount =
    //       double.tryParse(level2ConsumptionController.text)));
    // level2UnitController = TextEditingController()
    //   ..addListener(() => setState(
    //       () => heater.level2ConsumptionUnit = level2UnitController.text));
    // level2CarbonController = TextEditingController()
    //   ..addListener(() => setState(() =>
    //       heater.level2Carbon = double.tryParse(level2CarbonController.text)));
    // level3ConsumptionController = TextEditingController()
    //   ..addListener(() => setState(() => heater.level3ConsumptionAmount =
    //       double.tryParse(level3ConsumptionController.text)));
    // level3UnitController = TextEditingController()
    //   ..addListener(() => setState(
    //       () => heater.level3ConsumptionUnit = level3UnitController.text));
    // level3CarbonController = TextEditingController()
    //   ..addListener(() => setState(() =>
    //       heater.level3Carbon = double.tryParse(level3CarbonController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) {
        final Widget viewSelectType = //MARK: HEATER TYPE
            WizardPageContentWidget(
          title: 'Select Type',
          children: [
            FormItemComponent(
              label: 'What is the type of your Heater',
              child: TypeDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    heater = heater.copyWith(type: value ?? HeaterDeviceType.none);
                  });
                },
                value: heater.type,
              ),
            ),
          ],
        );

        final Widget viewSelectConnectionType = //MARK: CONNECTION TYPE
            WizardPageContentWidget(
          title: 'Select Connection',
          children: [
            FormItemComponent(
              label: 'How do you connect heater?',
              child: ConnectionTypeDropdownWidget(
                onChanged: (value) {
                  setState(() {
                    heater = heater.copyWith(connectionType: value ?? HeaterDeviceConnectionType.none);
                  });
                },
                value: heater.connectionType,
              ),
            ),
          ],
        );

        final Widget viewSelectLevel = //MARK: LEVEL
            WizardPageContentWidget(
          title: 'Select Level Option',
          children: [
            FormItemComponent(
              label: 'How many levels does your heater has',
              child: LevelTypeDropdownWidget(
                value: heater.levelType,
                onChanged: (value) {
                  setState(() {
                    heater = heater.copyWith(levelType: value ?? HeaterDeviceLevel.none);
                  });
                },
              ),
            ),
          ],
        );

        final Widget viewSelectChannel = //MARK: CHANNEL
            WizardPageContentWidget(
          title: 'Select Channels',
          children: [
            heater.levelType == HeaterDeviceLevel.none
                ? Center(
                    child: ElevatedButton(
                      onPressed: () {
                        pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Select Level Option'),
                    ),
                  )
                : heater.connectionType == HeaterDeviceConnectionType.relay
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              //MARK: LEVEL 1 OUTPUT
                              Expanded(
                                child: FormItemComponent(
                                  label: 'On/Level 1 Output Channel',
                                  child: ChannelDropdownWidget(
                                    group: GpioGroup.outPin,
                                    onChanged: (value) {
                                      setState(
                                          () => heater = heater.copyWith(outputChannel1: value));
                                    },
                                    value: heater.outputChannel1,
                                  ),
                                ),
                              ),

                              //MARK: LEVEL 2 OUTPUT
                              if (heater.levelType ==
                                      HeaterDeviceLevel.threeLevels ||
                                  heater.levelType ==
                                      HeaterDeviceLevel.twoLevels)
                                Expanded(
                                  child: FormItemComponent(
                                    label: 'High/Level 2 Output Channel',
                                    child: ChannelDropdownWidget(
                                      group: GpioGroup.outPin,
                                      onChanged: (value) {
                                        setState(() =>
                                            heater = heater.copyWith(outputChannel2: value));
                                      },
                                      value: heater.outputChannel2,
                                    ),
                                  ),
                                ),

                              //MARK: LEVEL 3 OUTPUT
                              if (heater.levelType ==
                                  HeaterDeviceLevel.threeLevels)
                                Expanded(
                                  child: FormItemComponent(
                                    label: 'Max/Level 3 Output Channel',
                                    child: ChannelDropdownWidget(
                                      group: GpioGroup.outPin,
                                      onChanged: (value) {
                                        setState(() =>
                                            heater = heater.copyWith(outputChannel3: value));
                                      },
                                      value: heater.outputChannel3,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            spacing: 8,
                            children: [
                              //MARK: INPUT
                              Expanded(
                                flex: 3,
                                child: FormItemComponent(
                                  label: 'Error Input Channel',
                                  child: ChannelDropdownWidget(
                                    group: GpioGroup.inPin,
                                    onChanged: (value) {
                                      setState(
                                          () => heater = heater.copyWith(errorChannel: value));
                                    },
                                    value: heater.errorChannel,
                                  ),
                                ),
                              ),

                              //MARK: INPUT Type
                              Expanded(
                                flex: 2,
                                child: FormItemComponent(
                                  label: 'Please Select Input Channel Type',
                                  child: ErrorChannelTypeDropdownWidget(
                                    value: heater.errorChannelType,
                                    onChanged: (value) {
                                      setState(() {
                                        heater = heater.copyWith(errorChannelType: value ?? ErrorChannelType.nC);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : heater.connectionType ==
                            HeaterDeviceConnectionType.ethernet
                        ?
                        // MARK: IP Address
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormItemComponent(
                                label: 'Enter the IP Address of your heater',
                                child: TextField(
                                  controller: ipAddressController,
                                  decoration: InputDecoration(
                                    border: UiDimens.formBorder,
                                    hintText: 'eg: 192.168.1.156',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: ElevatedButton(
                              onPressed: () {
                                pageController.animateToPage(
                                  1,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: const Text('Select Connection Type'),
                            ),
                          ),
          ],
        );

        final Widget viewEnterConsumption = //MARK: CONSUMPTION
            WizardPageContentWidget(
          title: 'Enter Consumption & Emissions',
          children: [
            const Text('Please enter Consumption Values and CO2 emissions'),
            const SizedBox(height: 20),
            //MARK: Consumption Header
            Row(
              children: [
                Expanded(child: Container()),
                const Expanded(
                  child: Text(
                    'Consumption\nAmount',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Consumption\nUnit',
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'CO2\nEmission',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            //MARK: LEVEL 1 CONSUMPTION
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(child: Text('Level 1')),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    // controller: level1ConsumptionController,
                    decoration: InputDecoration(
                      border: UiDimens.formBorder,
                      hintText: '0.0',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    // controller: level1UnitController,
                    decoration: InputDecoration(
                      border: UiDimens.formBorder,
                      hintText: heater.type == HeaterDeviceType.electric
                          ? 'kwH'
                          : 'm³',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    // controller: level1CarbonController,
                    decoration: InputDecoration(
                      border: UiDimens.formBorder,
                      hintText: 'kt',
                    ),
                  ),
                ),
              ],
            ),

            //MARK: LEVEL 2 CONSUMPTION
            if (heater.levelType == HeaterDeviceLevel.twoLevels ||
                heater.levelType == HeaterDeviceLevel.threeLevels)
              const SizedBox(height: 12),
            if (heater.levelType == HeaterDeviceLevel.twoLevels ||
                heater.levelType == HeaterDeviceLevel.threeLevels)
              Row(
                children: [
                  const Expanded(child: Text('Level 2')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      // controller: level2ConsumptionController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        hintText: '0.0',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      // controller: level2UnitController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        hintText: heater.type == HeaterDeviceType.electric
                            ? 'kwH'
                            : 'm³',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      // controller: level2CarbonController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        hintText: 'kt',
                      ),
                    ),
                  ),
                ],
              ),

            //MARK: LEVEL 3 CONSUMPTION
            if (heater.levelType == HeaterDeviceLevel.threeLevels)
              const SizedBox(height: 12),
            if (heater.levelType == HeaterDeviceLevel.threeLevels)
              Row(
                children: [
                  const Expanded(child: Text('Level 3')),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      // controller: level3ConsumptionController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        hintText: '0.0',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      // controller: level3UnitController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        hintText: heater.type == HeaterDeviceType.electric
                            ? 'kwH'
                            : 'm³',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      // controller: level3CarbonController,
                      decoration: InputDecoration(
                        border: UiDimens.formBorder,
                        hintText: 'kt',
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );

        final Widget viewEnterName = //MARK: NAME-COLOR
            WizardPageContentWidget(
          title: 'Labeling',
          children: [
            FormItemComponent(
              label: 'Select Zone',
              child: ZoneDropdownWidget(
                value:
                    dc.zoneList.firstWhereOrNull((e) => e.id == heater.zoneId),
                onChanged: (value) {
                  if (value == null) {
                    setState(() {
                      heater = heater.copyWith(zoneId: null);
                    });
                  } else {
                    setState(() {
                      heater = heater.copyWith(zoneId: value.id);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            FormItemComponent(
              label: 'Name',
              child: TextField(
                onTap: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    initialValue: heater.name,
                    label: 'Heater Name',
                    type: OSKInputType.name,
                  );
                  setState(() {
                    nameController.text = result;
                  });
                },
                controller: nameController,
                readOnly: true,
                decoration: InputDecoration(
                  border: UiDimens.formBorder,
                  hintText: 'Type a name here',
                ),
              ),
            ),
            const SizedBox(height: 12),
            FormItemComponent(
              label: 'Pick a color',
              child: ColorPickerWidget(
                selectedValue: heater.color,
                onSelected: (value) {
                  setState(() {
                    heater = heater.copyWith(color: value);
                  });
                },
              ),
            ),
          ],
        );

        final Widget viewDisplaySummary = //MARK: SUMMARY
            WizardPageContentWidget(
          title: 'Summary',
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormItemComponent(
                        label: 'Heater Name',
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                CommonUtils.hexToColor(context, heater.color),
                            borderRadius: UiDimens.formRadius,
                          ),
                          child: Text(heater.name),
                        ),
                      ),
                      FormItemComponent(
                          label: 'Zone',
                          child: Text(heater.zoneId == null
                              ? 'No zone'
                              : dc.zoneList
                                      .firstWhereOrNull(
                                          (e) => e.id == heater.zoneId)
                                      ?.name ??
                                  '')),
                      FormItemComponent(
                        label: 'Type',
                        child:
                            Text(heater.type.name.camelCaseToHumanReadable()),
                      ),
                      FormItemComponent(
                        label: 'Connection',
                        child: Text(heater.connectionType.name
                            .camelCaseToHumanReadable()),
                      ),
                      FormItemComponent(
                        label: 'Level Option',
                        child: Text(
                            heater.levelType.name.camelCaseToHumanReadable()),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /* FormItemComponent(
                                label: 'Channels',
                                child: Text(
                                    'out: ${heater.outputChannel1?.name}'
                                    '${heater.levelType == HeaterDeviceLevel.threeLevels || heater.levelType == HeaterDeviceLevel.twoLevels ? ', ${heater.level2Relay?.name}' : ''}'
                                    '${heater.levelType == HeaterDeviceLevel.threeLevels ? ', ${heater.level3Relay?.name}' : ''}'
                                    '\nin: ${heater.errorChannel?.name} (${heater.errorChannelType?.name})'),
                              ),
                              FormItemComponent(
                                label: 'Consumption on Level 1',
                                child: Text('${CCUtils.displayConsumption(
                                  consumptionAmount:
                                      heater.level1ConsumptionAmount,
                                  consumptionUnit: heater.level1ConsumptionUnit,
                                )}  (${CCUtils.displayCarbon(heater.level1Carbon)})'),
                              ),
                              FormItemComponent(
                                label: 'Consumption on Level 2',
                                child: Text('${CCUtils.displayConsumption(
                                  consumptionAmount:
                                      heater.level2ConsumptionAmount,
                                  consumptionUnit: heater.level2ConsumptionUnit,
                                )}  (${CCUtils.displayCarbon(heater.level2Carbon)})'),
                              ),
                              FormItemComponent(
                                label: 'Consumption on Level 3',
                                child: Text('${CCUtils.displayConsumption(
                                  consumptionAmount:
                                      heater.level3ConsumptionAmount,
                                  consumptionUnit: heater.level3ConsumptionUnit,
                                )}  (${CCUtils.displayCarbon(heater.level3Carbon)})'),
                              ), */
                    ],
                  ),
                ),
              ],
            ),
          ],
        );

        final List<Widget> pages = [
          viewSelectType,
          viewSelectConnectionType,
          viewSelectLevel,
          viewSelectChannel,
          // viewEnterConsumption,
          viewEnterName,
          viewDisplaySummary,
        ];

        return AppScaffold(
          title: 'Add a Heater ${currentPage + 1} / ${pages.length}',
          selectedIndex: 3,
          body: Stack(
            children: [
              PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: pages,
                onPageChanged: (p) {},
              ),
              if (currentPage > 0) previousButton,
              currentPage > (pages.length - 2)
                  ? saveButton(context)
                  : nextButton(pages.length),
            ],
          ),
        );
      },
    );
  }

  // Widget indicator({
  //   required String label,
  //   String? value,
  //   required bool isValid,
  //   required Function() clearCallback,
  // }) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(label),
  //         isValid
  //             ? Chip(
  //                 label: Text(value ?? ''),
  //                 deleteIcon: const Icon(Icons.close),
  //                 onDeleted: clearCallback,
  //               )
  //             : const Text('-'),
  //       ],
  //     ),
  //   );
  // }

  Widget nextButton(int pagesLength) => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: currentPage <= (pagesLength - 2)
                ? () {
                    Buzz.feedback();
                    pageController.animateToPage(
                      currentPage + 1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            child: const Text('Next'),
          ),
        ),
      );

  Widget get previousButton => Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: currentPage > 0
                ? () {
                    Buzz.feedback();
                    pageController.animateToPage(
                      currentPage - 1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            child: const Text('Previous'),
          ),
        ),
      );

  Widget saveButton(BuildContext context) => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: heater.name.isNotEmpty &&
                    heater.type != HeaterDeviceType.none &&
                    heater.connectionType != HeaterDeviceConnectionType.none
                ? () async {
                    final DataController dc = Get.find();
                    final result = await dc.addHeater(heater);
                    if (result) {
                      Buzz.success();
                      if (context.mounted) {
                        DialogUtils.snackbar(
                          context: context,
                          message: 'Heater saved',
                          type: SnackbarType.success,
                        );
                      }

                      Get.back();
                    } else {
                      Buzz.error();
                      if (context.mounted) {
                        DialogUtils.snackbar(
                          context: context,
                          message:
                              'Unexpected error occured. Please check entered information and try again',
                          type: SnackbarType.error,
                        );
                      }
                    }
                  }
                : null,
            child: const Text("Save"),
          ),
        ),
      );

  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );
}

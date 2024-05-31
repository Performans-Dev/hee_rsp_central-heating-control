import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/channel.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/connection_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/error_channel_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/level_type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/type.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/zone.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsHeaterAddScreen extends StatefulWidget {
  const SettingsHeaterAddScreen({super.key});

  @override
  State<SettingsHeaterAddScreen> createState() =>
      _SettingsHeaterAddScreenState();
}

class _SettingsHeaterAddScreenState extends State<SettingsHeaterAddScreen> {
  HeaterDevice heater = HeaterDevice.initial();
  late PageController pageController;
  int currentPage = 0;
  late TextEditingController nameController;
  late TextEditingController ipAddressController;
  late TextEditingController level1ConsumptionController;
  late TextEditingController level1UnitController;
  late TextEditingController level1CarbonController;
  late TextEditingController level2ConsumptionController;
  late TextEditingController level2UnitController;
  late TextEditingController level2CarbonController;
  late TextEditingController level3ConsumptionController;
  late TextEditingController level3UnitController;
  late TextEditingController level3CarbonController;

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
    level1CarbonController = TextEditingController()
      ..addListener(() => setState(() =>
          heater.level1Carbon = double.tryParse(level1CarbonController.text)));
    level2ConsumptionController = TextEditingController()
      ..addListener(() => setState(() => heater.level2ConsumptionAmount =
          double.tryParse(level2ConsumptionController.text)));
    level2UnitController = TextEditingController()
      ..addListener(() => setState(
          () => heater.level2ConsumptionUnit = level2UnitController.text));
    level2CarbonController = TextEditingController()
      ..addListener(() => setState(() =>
          heater.level2Carbon = double.tryParse(level2CarbonController.text)));
    level3ConsumptionController = TextEditingController()
      ..addListener(() => setState(() => heater.level3ConsumptionAmount =
          double.tryParse(level3ConsumptionController.text)));
    level3UnitController = TextEditingController()
      ..addListener(() => setState(
          () => heater.level3ConsumptionUnit = level3UnitController.text));
    level3CarbonController = TextEditingController()
      ..addListener(() => setState(() =>
          heater.level3Carbon = double.tryParse(level3CarbonController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) => AppScaffold(
        title: 'Add a Heater $currentPage',
        selectedIndex: 3,
        body: Stack(
          children: [
            PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                //MARK: HEATER TYPE
                Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(60),
                  child: FormItemComponent(
                    label: 'What is the type of your Heater',
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
                //MARK: CONNECTION TYPE
                Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(60),
                  child: FormItemComponent(
                    label: 'How do you connect heater?',
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
                //MARK: LEVEL
                Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(60),
                  child: FormItemComponent(
                    label: 'How many levels does your heater has',
                    child: LevelTypeDropdownWidget(
                      value: heater.levelType,
                      onChanged: (value) {
                        setState(() {
                          heater.levelType = value ?? HeaterDeviceLevel.none;
                        });
                      },
                    ),
                  ),
                ),
                //MARK: ERROR INPUT CHANNEL || IP ADDRESS
                Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(60),
                  child: heater.levelType == HeaterDeviceLevel.none
                      ? Center(
                          child: ElevatedButton(
                            onPressed: () {
                              pageController.animateToPage(
                                2,
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Text('Select Level Option'),
                          ),
                        )
                      : heater.connectionType ==
                              HeaterDeviceConnectionType.relay
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    //MARK: LEVEL 1 OUTPUT
                                    Expanded(
                                      child: FormItemComponent(
                                        label: 'On/Level1 Output Channel',
                                        child: ChannelDropdownWidget(
                                          group: GpioGroup.inPin,
                                          value: heater.level1Relay,
                                          onChanged: (value) {
                                            setState(() {
                                              heater.level1Relay =
                                                  (value?.id ?? '').isEmpty
                                                      ? null
                                                      : value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),

                                    //MARK: LEVEL 2 OUTPUT
                                    if (heater.levelType ==
                                            HeaterDeviceLevel.threeLevels ||
                                        heater.levelType ==
                                            HeaterDeviceLevel.twoLevels)
                                      SizedBox(width: 8),
                                    if (heater.levelType ==
                                            HeaterDeviceLevel.threeLevels ||
                                        heater.levelType ==
                                            HeaterDeviceLevel.twoLevels)
                                      Expanded(
                                        child: FormItemComponent(
                                          label: 'Level2 Output Channel',
                                          child: ChannelDropdownWidget(
                                            group: GpioGroup.inPin,
                                            value: heater.level2Relay,
                                            onChanged: (value) {
                                              setState(() {
                                                heater.level2Relay =
                                                    (value?.id ?? '').isEmpty
                                                        ? null
                                                        : value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),

                                    //MARK: LEVEL 3 OUTPUT
                                    if (heater.levelType ==
                                        HeaterDeviceLevel.threeLevels)
                                      SizedBox(width: 8),
                                    if (heater.levelType ==
                                        HeaterDeviceLevel.threeLevels)
                                      Expanded(
                                        child: FormItemComponent(
                                          label: 'Level3 Output Channel',
                                          child: ChannelDropdownWidget(
                                            group: GpioGroup.inPin,
                                            value: heater.level3Relay,
                                            onChanged: (value) {
                                              setState(() {
                                                heater.level3Relay =
                                                    (value?.id ?? '').isEmpty
                                                        ? null
                                                        : value;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    //MARK: INPUT
                                    Expanded(
                                      flex: 3,
                                      child: FormItemComponent(
                                        label: 'Please Select Input Channel',
                                        child: ChannelDropdownWidget(
                                          group: GpioGroup.inPin,
                                          value: heater.errorChannel,
                                          onChanged: (value) {
                                            setState(() {
                                              heater.errorChannel =
                                                  (value?.id ?? '').isEmpty
                                                      ? null
                                                      : value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),

                                    //MARK: INPUT Type
                                    Expanded(
                                      flex: 2,
                                      child: FormItemComponent(
                                        label:
                                            'Please Select Input Channel Type',
                                        child: ErrorChannelTypeDropdownWidget(
                                          value: heater.errorChannelType,
                                          onChanged: (value) {
                                            setState(() {
                                              heater.errorChannelType =
                                                  value ?? ErrorChannelType.nA;
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
                                      label:
                                          'Enter the IP Address of your heater',
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
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Text('Select Connection Type'),
                                  ),
                                ),
                ),
                //MARK: CONSUMPTION
                Container(
                  constraints: BoxConstraints.expand(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Please enter Consumption Values and CO2 emissions'),
                      SizedBox(height: 20),
                      //MARK: Consumption Header
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Expanded(
                            child: Text(
                              'Consumption\nAmount',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Consumption\nUnit',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'CO2\nEmission',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      //MARK: LEVEL 1 CONSUMPTION
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: Text('Level 1')),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: level1ConsumptionController,
                              decoration: InputDecoration(
                                border: UiDimens.formBorder,
                                hintText: '0.0',
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: level1UnitController,
                              decoration: InputDecoration(
                                border: UiDimens.formBorder,
                                hintText:
                                    heater.type == HeaterDeviceType.electric
                                        ? 'kwH'
                                        : 'm3',
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: level1CarbonController,
                              decoration: InputDecoration(
                                border: UiDimens.formBorder,
                                hintText: 'mg',
                              ),
                            ),
                          ),
                        ],
                      ),

                      //MARK: LEVEL 2 CONSUMPTION
                      if (heater.levelType == HeaterDeviceLevel.twoLevels ||
                          heater.levelType == HeaterDeviceLevel.threeLevels)
                        SizedBox(height: 12),
                      if (heater.levelType == HeaterDeviceLevel.twoLevels ||
                          heater.levelType == HeaterDeviceLevel.threeLevels)
                        Row(
                          children: [
                            Expanded(child: Text('Level 2')),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: level2ConsumptionController,
                                decoration: InputDecoration(
                                  border: UiDimens.formBorder,
                                  hintText: '0.0',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: level2UnitController,
                                decoration: InputDecoration(
                                  border: UiDimens.formBorder,
                                  hintText:
                                      heater.type == HeaterDeviceType.electric
                                          ? 'kwH'
                                          : 'm3',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: level2CarbonController,
                                decoration: InputDecoration(
                                  border: UiDimens.formBorder,
                                  hintText: 'mg',
                                ),
                              ),
                            ),
                          ],
                        ),

                      //MARK: LEVEL 3 CONSUMPTION
                      if (heater.levelType == HeaterDeviceLevel.threeLevels)
                        SizedBox(height: 12),
                      if (heater.levelType == HeaterDeviceLevel.threeLevels)
                        Row(
                          children: [
                            Expanded(child: Text('Level 3')),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: level3ConsumptionController,
                                decoration: InputDecoration(
                                  border: UiDimens.formBorder,
                                  hintText: '0.0',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: level3UnitController,
                                decoration: InputDecoration(
                                  border: UiDimens.formBorder,
                                  hintText:
                                      heater.type == HeaterDeviceType.electric
                                          ? 'kwH'
                                          : 'm3',
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: level3CarbonController,
                                decoration: InputDecoration(
                                  border: UiDimens.formBorder,
                                  hintText: 'mg',
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  padding: EdgeInsets.all(60),
                ),
                //MARK: NAME-COLOR
                Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormItemComponent(
                        label: 'Name',
                        child: TextField(
                          onTap: () async {
                            final result = await OSKKey.show(
                              initialValue: heater.name,
                              label: 'Heater Name',
                              type: OSKKeyInputType.name,
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
                      SizedBox(height: 12),
                      FormItemComponent(
                        label: 'Pick a color',
                        child: ColorPickerWidget(
                          selectedValue: heater.color,
                          onSelected: (value) {
                            setState(() {
                              heater.color = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                //MARK: SUMMARY
                Container(
                  constraints: BoxConstraints.expand(),
                  padding: EdgeInsets.all(60),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${heater.name}'),
                      Text(
                          'Type: ${heater.type.name.camelCaseToHumanReadable()}'),
                      Text(
                          'Connection: ${heater.connectionType.name.camelCaseToHumanReadable()}'),
                      Text(
                          'Level Settings: ${heater.levelType.name.camelCaseToHumanReadable()}'),
                      Text('Channels:'),
                      Text('Consumptions:'),
                      Text(
                          'Level1 ${heater.level1ConsumptionAmount}${heater.level1ConsumptionUnit} (${heater.level1Carbon})'),
                      Text(
                          'Level2 ${heater.level2ConsumptionAmount}${heater.level2ConsumptionUnit} (${heater.level2Carbon})'),
                      Text(
                          'Level3 ${heater.level3ConsumptionAmount}${heater.level3ConsumptionUnit} (${heater.level3Carbon})'),
                    ],
                  ),
                ),
              ],
              onPageChanged: (p) {},
            ),
            if (currentPage > 0) previousButton,
            currentPage > 5 ? saveButton : nextButton,
          ],
        ),

        // PiScrollView(
        //   child: Container(),
        //   //  Column(
        //   //   mainAxisSize: MainAxisSize.min,
        //   //   crossAxisAlignment: CrossAxisAlignment.start,
        //   //   children: [
        //   //     // Row(
        //   //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   //     //   children: [
        //   //     //     indicator(
        //   //     //         label: 'Type',
        //   //     //         value: heater.type.name.camelCaseToHumanReadable(),
        //   //     //         isValid: heater.type != HeaterDeviceType.none,
        //   //     //         clearCallback: () {
        //   //     //           setState(() {
        //   //     //             heater.type = HeaterDeviceType.none;
        //   //     //           });
        //   //     //         }),
        //   //     //     indicator(
        //   //     //         label: 'Connection',
        //   //     //         value:
        //   //     //             heater.connectionType.name.camelCaseToHumanReadable(),
        //   //     //         isValid: heater.connectionType !=
        //   //     //             HeaterDeviceConnectionType.none,
        //   //     //         clearCallback: () {
        //   //     //           setState(() {
        //   //     //             heater.connectionType =
        //   //     //                 HeaterDeviceConnectionType.none;
        //   //     //           });
        //   //     //         }),
        //   //     //     indicator(
        //   //     //         label: 'Level',
        //   //     //         value: heater.levelType.name.camelCaseToHumanReadable(),
        //   //     //         isValid: heater.levelType != HeaterDeviceLevel.none,
        //   //     //         clearCallback: () {
        //   //     //           setState(() {
        //   //     //             heater.levelType = HeaterDeviceLevel.none;
        //   //     //           });
        //   //     //         }),
        //   //     //     heater.connectionType == HeaterDeviceConnectionType.ethernet
        //   //     //         ? indicator(
        //   //     //             label: 'Ip Address',
        //   //     //             value: heater.ipAddress,
        //   //     //             isValid: heater.connectionType ==
        //   //     //                     HeaterDeviceConnectionType.ethernet &&
        //   //     //                 CommonUtils.isValidIPAddress(
        //   //     //                     heater.ipAddress ?? ''),
        //   //     //             clearCallback: () {
        //   //     //               setState(() {
        //   //     //                 heater.ipAddress = null;
        //   //     //               });
        //   //     //             },
        //   //     //           )
        //   //     //         : heater.connectionType ==
        //   //     //                 HeaterDeviceConnectionType.relay
        //   //     //             ? indicator(
        //   //     //                 label: 'Error Channel',
        //   //     //                 value: heater.errorChannel?.name,
        //   //     //                 isValid: heater.errorChannel != null,
        //   //     //                 clearCallback: () {
        //   //     //                   setState(() {
        //   //     //                     heater.errorChannel = null;
        //   //     //                   });
        //   //     //                 },
        //   //     //               )
        //   //     //             : Container(),
        //   //     //     indicator(
        //   //     //       label: 'Consumptions',
        //   //     //       value:
        //   //     //           '${heater.level1ConsumptionAmount} ${heater.level1ConsumptionUnit}',
        //   //     //       isValid: heater.level1ConsumptionAmount != null,
        //   //     //       clearCallback: () {
        //   //     //         setState(() {
        //   //     //           heater.level1ConsumptionAmount = null;
        //   //     //           heater.level1ConsumptionUnit = null;
        //   //     //           heater.level1Carbon = null;
        //   //     //           heater.level2ConsumptionAmount = null;
        //   //     //           heater.level2ConsumptionUnit = null;
        //   //     //           heater.level2Carbon = null;
        //   //     //           heater.level3ConsumptionAmount = null;
        //   //     //           heater.level3ConsumptionUnit = null;
        //   //     //           heater.level3Carbon = null;
        //   //     //         });
        //   //     //       },
        //   //     //     ),
        //   //     //     indicator(
        //   //     //       label: 'Name',
        //   //     //       value: heater.name,
        //   //     //       isValid: heater.name.isNotEmpty,
        //   //     //       clearCallback: () {
        //   //     //         setState(() {
        //   //     //           heater.name = '';
        //   //     //         });
        //   //     //       },
        //   //     //     ),
        //   //     //     saveButton,
        //   //     //   ],
        //   //     // ),
        //   //     // (heater.type == HeaterDeviceType.none)
        //   //     //     ? Container(
        //   //     //         padding: const EdgeInsets.all(50),
        //   //     //         child: FormItemComponent(
        //   //     //           label: 'Pick Your Heater Type',
        //   //     //           child: TypeDropdownWidget(
        //   //     //             onChanged: (value) {
        //   //     //               setState(() {
        //   //     //                 heater.type = value ?? HeaterDeviceType.none;
        //   //     //               });
        //   //     //             },
        //   //     //             value: heater.type,
        //   //     //           ),
        //   //     //         ),
        //   //     //       )
        //   //     //     : heater.connectionType == HeaterDeviceConnectionType.none
        //   //     //         ? Container(
        //   //     //             padding: const EdgeInsets.all(50),
        //   //     //             child: FormItemComponent(
        //   //     //               label: 'Connection',
        //   //     //               child: ConnectionTypeDropdownWidget(
        //   //     //                 onChanged: (value) {
        //   //     //                   setState(() {
        //   //     //                     heater.connectionType =
        //   //     //                         value ?? HeaterDeviceConnectionType.none;
        //   //     //                   });
        //   //     //                 },
        //   //     //                 value: heater.connectionType,
        //   //     //               ),
        //   //     //             ),
        //   //     //           )
        //   //     //         : const Text('other')

        //   //     /*
        //   //     //#region NAME
        //   //     FormItemComponent(
        //   //       label: 'Name',
        //   //       child: TextField(
        //   //         controller: nameController,
        //   //         decoration: InputDecoration(border: UiDimens.formBorder),
        //   //       ),
        //   //     ),
        //   //     //#endregion

        //   //     Row(
        //   //       children: [
        //   //         //#region TYPE
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'Type',
        //   //             child: TypeDropdownWidget(
        //   //               onChanged: (value) {
        //   //                 setState(() {
        //   //                   heater.type = value ?? HeaterDeviceType.none;
        //   //                 });
        //   //               },
        //   //               value: heater.type,
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         //#endregion
        //   //         const SizedBox(width: 8),
        //   //         //#region CONNECTION
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'Connection',
        //   //             child: ConnectionTypeDropdownWidget(
        //   //               onChanged: (value) {
        //   //                 setState(() {
        //   //                   heater.connectionType =
        //   //                       value ?? HeaterDeviceConnectionType.none;
        //   //                 });
        //   //               },
        //   //               value: heater.connectionType,
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         //#endregion
        //   //         const SizedBox(width: 8),
        //   //         //#region LEVEL Type
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'Level Type',
        //   //             child: LevelTypeDropdownWidget(
        //   //               onChanged: (value) {
        //   //                 setState(() {
        //   //                   heater.levelType = value ?? HeaterDeviceLevel.onOff;
        //   //                 });
        //   //               },
        //   //               value: heater.levelType,
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         //#endregion
        //   //         const SizedBox(width: 8),
        //   //         //#region ZONE
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'Zone',
        //   //             child: ZoneDropdownWidget(
        //   //               onChanged: (value) {
        //   //                 setState(() {
        //   //                   heater.zoneId = value?.id;
        //   //                 });
        //   //               },
        //   //               value: dc.zoneList
        //   //                   .firstWhereOrNull((e) => e.id == heater.zoneId),
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         //#endregion
        //   //       ],
        //   //     ),

        //   //     //#region IP ADDRESS
        //   //     if (heater.connectionType == HeaterDeviceConnectionType.ethernet)
        //   //       FormItemComponent(
        //   //         label: 'Ip Addres',
        //   //         child: TextField(
        //   //           controller: ipAddressController,
        //   //           decoration: InputDecoration(border: UiDimens.formBorder),
        //   //         ),
        //   //       ),
        //   //     //#endregion

        //   //     //#region ERROR CHANNEL
        //   //     if (heater.connectionType == HeaterDeviceConnectionType.relay)
        //   //       Row(
        //   //         children: [
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //                 label: 'Error Channel',
        //   //                 child: ChannelDropdownWidget(
        //   //                   onChanged: (value) {
        //   //                     setState(() {
        //   //                       heater.errorChannel =
        //   //                           (value?.id ?? '').isEmpty ? null : value;
        //   //                     });
        //   //                   },
        //   //                   value: heater.errorChannel,
        //   //                   group: GpioGroup.inPin,
        //   //                 )),
        //   //           ),
        //   //           const SizedBox(width: 8),
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'Error Channel Type',
        //   //               child: ErrorChannelTypeDropdownWidget(
        //   //                 onChanged: (value) {
        //   //                   setState(() {
        //   //                     heater.errorChannelType = value;
        //   //                   });
        //   //                 },
        //   //                 value: heater.errorChannelType ?? ErrorChannelType.nO,
        //   //               ),
        //   //             ),
        //   //           ),
        //   //         ],
        //   //       ),
        //   //     //#endregion

        //   //     //#region L1
        //   //     Row(
        //   //       children: [
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'L1 Consumption Amount',
        //   //             child: TextField(
        //   //               controller: TextEditingController(
        //   //                   text: '${heater.level1ConsumptionAmount ?? 0}'),
        //   //               decoration:
        //   //                   InputDecoration(border: UiDimens.formBorder),
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         const SizedBox(width: 8),
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'L1 Consumption Unit',
        //   //             child: TextField(
        //   //               controller: TextEditingController(
        //   //                   text: heater.level1ConsumptionUnit ?? '-'),
        //   //               decoration:
        //   //                   InputDecoration(border: UiDimens.formBorder),
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         const SizedBox(width: 8),
        //   //         Expanded(
        //   //           child: FormItemComponent(
        //   //             label: 'L1 CO₂ Emission',
        //   //             child: TextField(
        //   //               controller: TextEditingController(
        //   //                   text: '${heater.level1Carbon ?? 0}'),
        //   //               decoration:
        //   //                   InputDecoration(border: UiDimens.formBorder),
        //   //             ),
        //   //           ),
        //   //         ),
        //   //         if (heater.connectionType == HeaterDeviceConnectionType.relay)
        //   //           const SizedBox(width: 8),
        //   //         if (heater.connectionType == HeaterDeviceConnectionType.relay)
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'Level 1 Relay',
        //   //               child: ChannelDropdownWidget(
        //   //                 onChanged: (value) {
        //   //                   setState(() {
        //   //                     heater.level1Relay =
        //   //                         (value?.id ?? '').isEmpty ? null : value;
        //   //                   });
        //   //                 },
        //   //                 value: heater.level1Relay,
        //   //                 group: GpioGroup.outPin,
        //   //               ),
        //   //             ),
        //   //           ),
        //   //       ],
        //   //     ),
        //   //     //#endregion

        //   //     //#region L2
        //   //     if (heater.levelType == HeaterDeviceLevel.threeLevels ||
        //   //         heater.levelType == HeaterDeviceLevel.twoLevels)
        //   //       Row(
        //   //         children: [
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'L2 Consumption Amount',
        //   //               child: TextField(
        //   //                 controller: TextEditingController(
        //   //                     text: '${heater.level2ConsumptionAmount ?? 0}'),
        //   //                 decoration:
        //   //                     InputDecoration(border: UiDimens.formBorder),
        //   //               ),
        //   //             ),
        //   //           ),
        //   //           const SizedBox(width: 8),
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'L2 Consumption Unit',
        //   //               child: TextField(
        //   //                 controller: TextEditingController(
        //   //                     text: heater.level2ConsumptionUnit ?? '-'),
        //   //                 decoration:
        //   //                     InputDecoration(border: UiDimens.formBorder),
        //   //               ),
        //   //             ),
        //   //           ),
        //   //           const SizedBox(width: 8),
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'L2 CO₂ Emission',
        //   //               child: TextField(
        //   //                 controller: TextEditingController(
        //   //                     text: '${heater.level2Carbon ?? 0}'),
        //   //                 decoration:
        //   //                     InputDecoration(border: UiDimens.formBorder),
        //   //               ),
        //   //             ),
        //   //           ),
        //   //           if (heater.connectionType ==
        //   //               HeaterDeviceConnectionType.relay)
        //   //             const SizedBox(width: 8),
        //   //           if (heater.connectionType ==
        //   //               HeaterDeviceConnectionType.relay)
        //   //             Expanded(
        //   //               child: FormItemComponent(
        //   //                 label: 'Level 2 Relay',
        //   //                 child: ChannelDropdownWidget(
        //   //                   onChanged: (value) {
        //   //                     setState(() {
        //   //                       heater.level2Relay =
        //   //                           (value?.id ?? '').isEmpty ? null : value;
        //   //                     });
        //   //                   },
        //   //                   value: heater.level2Relay,
        //   //                   group: GpioGroup.outPin,
        //   //                 ),
        //   //               ),
        //   //             ),
        //   //         ],
        //   //       ),
        //   //     //#endregion

        //   //     //#region L3
        //   //     if (heater.levelType == HeaterDeviceLevel.threeLevels)
        //   //       Row(
        //   //         children: [
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'L3 Consumption Amount',
        //   //               child: TextField(
        //   //                 controller: TextEditingController(
        //   //                     text: '${heater.level3ConsumptionAmount ?? 0}'),
        //   //                 decoration:
        //   //                     InputDecoration(border: UiDimens.formBorder),
        //   //               ),
        //   //             ),
        //   //           ),
        //   //           const SizedBox(width: 8),
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'L3 Consumption Unit',
        //   //               child: TextField(
        //   //                 controller: TextEditingController(
        //   //                     text: heater.level3ConsumptionUnit ?? '-'),
        //   //                 decoration:
        //   //                     InputDecoration(border: UiDimens.formBorder),
        //   //               ),
        //   //             ),
        //   //           ),
        //   //           const SizedBox(width: 8),
        //   //           Expanded(
        //   //             child: FormItemComponent(
        //   //               label: 'L3 CO₂ Emission',
        //   //               child: TextField(
        //   //                 controller: TextEditingController(
        //   //                     text: '${heater.level3Carbon ?? 0}'),
        //   //                 decoration:
        //   //                     InputDecoration(border: UiDimens.formBorder),
        //   //               ),
        //   //             ),
        //   //           ),
        //   //           if (heater.connectionType ==
        //   //               HeaterDeviceConnectionType.relay)
        //   //             const SizedBox(width: 8),
        //   //           if (heater.connectionType ==
        //   //               HeaterDeviceConnectionType.relay)
        //   //             Expanded(
        //   //               child: FormItemComponent(
        //   //                 label: 'Level 3 Relay',
        //   //                 child: ChannelDropdownWidget(
        //   //                   onChanged: (value) {
        //   //                     setState(() {
        //   //                       heater.level3Relay =
        //   //                           (value?.id ?? '').isEmpty ? null : value;
        //   //                     });
        //   //                   },
        //   //                   value: heater.level3Relay,
        //   //                   group: GpioGroup.outPin,
        //   //                 ),
        //   //               ),
        //   //             ),
        //   //         ],
        //   //       ),
        //   //     //#endregion

        //   //     //#region COLOR
        //   //     FormItemComponent(
        //   //       label: 'Display Color',
        //   //       child: Container(
        //   //         decoration: BoxDecoration(
        //   //             border: Border.all(),
        //   //             color: Theme.of(context)
        //   //                 .inputDecorationTheme
        //   //                 .border
        //   //                 ?.borderSide
        //   //                 .color,
        //   //             borderRadius: UiDimens.formRadius),
        //   //         alignment: Alignment.centerLeft,
        //   //         padding: const EdgeInsets.all(4),
        //   //         child: ColorPickerWidget(
        //   //           onSelected: (v) => setState(() => heater.color = v),
        //   //           selectedValue: heater.color,
        //   //         ),
        //   //       ),
        //   //     ),
        //   //     //#endregion

        //   //     //
        //   //     Container(
        //   //       margin: const EdgeInsets.symmetric(vertical: 8),
        //   //       padding: const EdgeInsets.all(12),
        //   //       child: Row(
        //   //         mainAxisAlignment: MainAxisAlignment.end,
        //   //         children: [
        //   //           cancelButton,
        //   //           const SizedBox(width: 12),
        //   //           saveButton,
        //   //         ],
        //   //       ),
        //   //     ), */
        //   //   ],
        //   // ),
        // ),
      ),
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

  Widget get nextButton => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: currentPage <= 5
                ? () {
                    pageController.animateToPage(
                      currentPage + 1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            child: Text('Next'),
          ),
        ),
      );

  Widget get previousButton => Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: currentPage > 0
                ? () {
                    pageController.animateToPage(
                      currentPage - 1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  }
                : null,
            child: Text('Previous'),
          ),
        ),
      );

  Widget get saveButton => Align(
        alignment: Alignment.bottomRight,
        child: Container(
          padding: EdgeInsets.all(16),
          child: ElevatedButton(
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
          ),
        ),
      );

  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );
}

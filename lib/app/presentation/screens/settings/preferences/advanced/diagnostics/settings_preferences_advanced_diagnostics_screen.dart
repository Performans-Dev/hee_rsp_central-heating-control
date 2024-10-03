import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:central_heating_control/app/data/services/state.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesAdvancedDiagnosticsScreen extends StatefulWidget {
  const SettingsPreferencesAdvancedDiagnosticsScreen({super.key});

  @override
  State<SettingsPreferencesAdvancedDiagnosticsScreen> createState() =>
      _SettingsPreferencesAdvancedDiagnosticsScreenState();
}

class _SettingsPreferencesAdvancedDiagnosticsScreenState
    extends State<SettingsPreferencesAdvancedDiagnosticsScreen> {
  final GpioController gpioController = Get.find();
  final DataController dataController = Get.find();

  int selectedSerialDevice = 0x01;
  SerialCommand selectedSerialCommand = SerialCommand.test;
  int selectedSerialData1 = 0x00;
  int selectedSerialData2 = 0x00;
  List<int> serialDataPresets = [
    0x00,
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GpioController>(
      builder: (gc) {
        return GetBuilder<StateController>(
          builder: (sc) {
            final typeList =
                sc.stateList.map((e) => e.hardwareType).toSet().toList();

            return Scaffold(
              appBar: AppBar(
                title: const Text('Diagnostics'),
                actions: [
                  TextButton(
                      onPressed: () {
                        sc.populateList();
                      },
                      child: const Text('init'))
                ],
              ),
              body: PiScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...typeList.map(
                      (e) {
                        final typeListData = sc.stateList
                            .where((d) => d.hardwareType == e)
                            .toSet()
                            .toList();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(e.name),
                            ...typeListData.map((f) {
                              final typeDataWithDirection = sc.stateList
                                  .where((x) =>
                                      x.hardwareType == e &&
                                      x.pinType == f.pinType)
                                  .toList();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${f.title}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ...typeDataWithDirection.map(
                                        (z) => Card(
                                          margin: const EdgeInsets.all(2),
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('${z.title}'),
                                                z.pinType ==
                                                            PinType
                                                                .analogInput ||
                                                        z.pinType ==
                                                            PinType.analogOutput
                                                    ? Text('${z.pinValue}')
                                                    : Icon(
                                                        Icons.sunny,
                                                        color: z.pinValue
                                                            ? Colors.green
                                                            : Colors.grey,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }).toSet(),
                            Divider(),
                          ],
                        );
                      },
                    ),
                    Divider(),
                    Divider(),
                    Wrap(
                      children: sc.stateList
                          .map((e) => Card(
                                margin: const EdgeInsets.all(2),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    Text(e.hardwareType.name
                                        .camelCaseToHumanReadable()),
                                    Text(e.pinType.name
                                        .camelCaseToHumanReadable()),
                                    Text('${e.title}'),
                                    e.pinType == PinType.analogInput ||
                                            e.pinType == PinType.analogOutput
                                        ? Text('${e.pinValue}')
                                        : Icon(
                                            Icons.sunny,
                                            color: e.pinValue
                                                ? Colors.green
                                                : Colors.grey,
                                          ),
                                  ]),
                                ),
                              ))
                          .toList(),
                      /*                 
                     [
                      //MARK: SERIAL
                    
                      FormItemComponent(
                        label: 'Serial',
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ToggleButtons(
                                    isSelected: [
                                      selectedSerialDevice == 0x01,
                                      selectedSerialDevice != 0x01,
                                    ],
                                    onPressed: (v) {
                                      setState(() {
                                        selectedSerialDevice = v == 0 ? 0x01 : 0x02;
                                      });
                                    },
                                    children: const [
                                      Text('Device 1'),
                                      Text('Device 2'),
                                    ],
                                  ),
                                  ToggleButtons(
                                    isSelected: SerialCommand.values
                                        .map((e) => selectedSerialCommand == e)
                                        .toList(),
                                    onPressed: (v) {
                                      setState(() {
                                        selectedSerialCommand =
                                            SerialCommand.values[v];
                                      });
                                    },
                                    children: SerialCommand.values
                                        .map((e) =>
                                            Text(CommonUtils.bytesToHex([e.value])))
                                        .toList(),
                                  ),
                                  ToggleButtons(
                                    isSelected: serialDataPresets
                                        .map((e) => e == selectedSerialData1)
                                        .toList(),
                                    onPressed: (v) {
                                      setState(() {
                                        selectedSerialData1 = serialDataPresets[v];
                                      });
                                    },
                                    children: serialDataPresets
                                        .map((e) =>
                                            Text(CommonUtils.bytesToHex([e])))
                                        .toList(),
                                  ),
                                  ToggleButtons(
                                    isSelected: serialDataPresets
                                        .map((e) => e == selectedSerialData2)
                                        .toList(),
                                    onPressed: (v) {
                                      setState(() {
                                        selectedSerialData2 = serialDataPresets[v];
                                      });
                                    },
                                    children: serialDataPresets
                                        .map((e) =>
                                            Text(CommonUtils.bytesToHex([e])))
                                        .toList(),
                                  ),
                                  Text(CommonUtils.bytesToHex(gc.buildSerialMessage(
                                    id: selectedSerialDevice,
                                    command: selectedSerialCommand,
                                    data1: selectedSerialData1,
                                    data2: selectedSerialData2,
                                  ))),
                                  ElevatedButton(
                                    onPressed: () =>
                                        gc.sendSerialMessage(gc.buildSerialMessage(
                                      id: selectedSerialDevice,
                                      command: selectedSerialCommand,
                                      data1: selectedSerialData1,
                                      data2: selectedSerialData2,
                                    )),
                                    child: const Text('Send'),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(
                                    CommonUtils.uint8ListToHex(
                                        CommonUtils.intListToUint8List(
                                            gc.receivedSerialData[index])),
                                  ),
                                ),
                                itemCount: gc.receivedSerialData.length,
                              ),
                            )
                          ],
                        ),
                      ),
                    
                      const Divider(),
                      //MARK: OUT PINS
                      // FormItemComponent(
                      //   label: 'OUT PINS',
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       for (int i = 0; i < gc.outStates.length; i++)
                      //         Card(
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: UiDimens.formRadius,
                      //           ),
                      //           child: InkWell(
                      //             onTap: () => gc.onOutTap(i),
                      //             borderRadius: UiDimens.formRadius,
                      //             child: ClipRRect(
                      //               borderRadius: UiDimens.formRadius,
                      //               child: Container(
                      //                 padding: const EdgeInsets.all(10),
                      //                 child: Column(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: [
                      //                     Text('${UiData.outPins[i]}'),
                      //                     Icon(
                      //                       Icons.sunny,
                      //                       color: gc.outStates[i]
                      //                           ? Colors.red
                      //                           : Colors.grey.withOpacity(0.3),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //     ],
                      //   ),
                      // ),
                      const Divider(),
                      //MARK: IN PINS
                      FormItemComponent(
                        label: 'IN PINS',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 0; i < gc.inStates.length; i++)
                              Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${UiData.inPins[i]}'),
                                      Icon(
                                        Icons.sunny,
                                        color: !gc.inStates[i]
                                            ? Colors.green
                                            : Colors.grey.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(),
                      //MARK: BUTTONS
                      FormItemComponent(
                        label: 'BUTTONS',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 0; i < gc.btnStates.length; i++)
                              Card(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('${UiData.btnPins[i]}'),
                                      Icon(
                                        Icons.sunny,
                                        color: !gc.btnStates[i]
                                            ? Colors.green
                                            : Colors.grey.withOpacity(0.3),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(),
                      //MARK: BUZZER
                      FormItemComponent(
                        label: 'Buzzer',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (final item in BuzzerType.values)
                              Card(
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: UiDimens.formRadius,
                                ),
                                child: InkWell(
                                  onTap: () => gc.buzz(item),
                                  borderRadius: UiDimens.formRadius,
                                  child: ClipRRect(
                                    borderRadius: UiDimens.formRadius,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                          item.name.camelCaseToHumanReadable()),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const Divider(), 
                    ],*/
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

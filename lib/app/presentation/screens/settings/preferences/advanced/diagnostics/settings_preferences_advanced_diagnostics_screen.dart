import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
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
  late TextEditingController serialInputController;
  String serialMessage = '';
  bool busy = false;
  String txOpenResult = '';
  String txCloseResult = '';
  int selectedSerialDevice = 1;
  SerialCommand selectedSerialCommand = SerialCommand.test;
  int selectedSerialData1 = 0x00;
  int selectedSerialData2 = 0x00;

  @override
  void initState() {
    super.initState();
    serialInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GpioController>(
      builder: (gc) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Diagnostics'),
          ),
          body: PiScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                                child:
                                    Text(item.name.camelCaseToHumanReadable()),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(),
                FormItemComponent(
                  label: 'Serial',
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DropdownMenu(
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: 1, label: 'Device 1')
                            ],
                            enableSearch: false,
                            onSelected: (value) {
                              setState(() => selectedSerialDevice = value ?? 1);
                            },
                          ),
                          DropdownMenu<SerialCommand>(
                            dropdownMenuEntries: SerialCommand.values
                                .map((e) => DropdownMenuEntry(
                                      value: e,
                                      label: e.name.camelCaseToHumanReadable(),
                                    ))
                                .toList(),
                            enableSearch: false,
                            label: Text('Command'),
                            onSelected: (v) {
                              setState(() => selectedSerialCommand =
                                  v ?? SerialCommand.test);
                            },
                          ),
                          DropdownMenu<int>(
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: 0x00, label: '0x00'),
                              DropdownMenuEntry(value: 0x01, label: '0x01'),
                              DropdownMenuEntry(value: 0x02, label: '0x02'),
                              DropdownMenuEntry(value: 0x03, label: '0x03'),
                              DropdownMenuEntry(value: 0x04, label: '0x04'),
                              DropdownMenuEntry(value: 0x05, label: '0x05'),
                              DropdownMenuEntry(value: 0x06, label: '0x06'),
                            ],
                            enableSearch: false,
                            label: Text('Data1'),
                            onSelected: (v) {
                              setState(() => selectedSerialData1 = v ?? 0x00);
                            },
                          ),
                          DropdownMenu<int>(
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: 0x00, label: '0x00'),
                              DropdownMenuEntry(value: 0x01, label: '0x01'),
                              DropdownMenuEntry(value: 0x02, label: '0x02'),
                              DropdownMenuEntry(value: 0x03, label: '0x03'),
                              DropdownMenuEntry(value: 0x04, label: '0x04'),
                              DropdownMenuEntry(value: 0x05, label: '0x05'),
                              DropdownMenuEntry(value: 0x06, label: '0x06'),
                            ],
                            enableSearch: false,
                            label: Text('Data2'),
                            onSelected: (v) {
                              setState(() => selectedSerialData1 = v ?? 0x00);
                            },
                          ),
                          Expanded(
                            child: Center(
                              child: Text('${gc.buildSerialMessage(
                                id: selectedSerialDevice,
                                command: selectedSerialCommand,
                                data1: selectedSerialData1,
                                data2: selectedSerialData2,
                              )}'),
                            ),
                          ),
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
                      StreamBuilder(
                          stream: gc.serialMessageStreamController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(snapshot.data.toString());
                            }
                            return Container();
                          }),
                      // Text(gc.serialLog),
                    ],
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}

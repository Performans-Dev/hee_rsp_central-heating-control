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
                          // ElevatedButton(
                          //   onPressed: () async => await gc.serialSend(),
                          //   child: const Text('Serial Send'),
                          // ),
                          // ElevatedButton(
                          //   onPressed: () async => await gc.serialReceive(),
                          //   child: const Text('Serial Receive'),
                          // ),
                        ],
                      ),
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

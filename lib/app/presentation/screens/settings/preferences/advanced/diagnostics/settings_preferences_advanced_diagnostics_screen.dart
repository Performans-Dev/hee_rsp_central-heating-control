import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
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

  @override
  void initState() {
    super.initState();
    serialInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GpioController>(builder: (gpio) {
      Widget serialConsoleWidget = Row(
        children: [
          Expanded(
            child: TextField(
              controller: serialInputController,
              decoration: InputDecoration(labelText: gpio.serialKey),
            ),
          ),
          ElevatedButton(
            onPressed: busy ? null : onSendMessagePressed,
            child: const Text('Send'),
          ),
          const VerticalDivider(),
          ElevatedButton(
            onPressed: busy ? null : onReceiveMessagePressed,
            child: const Text('Receive'),
          ),
          Expanded(
            child: Text(serialMessage),
          ),
        ],
      );

      return Scaffold(
        appBar: AppBar(
          title: const Text('Diagnostics'),
        ),
        body: PiScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              serialConsoleWidget,
            ],
          ),
        ),
      );
    });
  }

  Future<void> onSendMessagePressed() async {
    setState(() => busy = true);
    await gpioController.serialSend(serialInputController.text);
    setState(() => busy = false);
  }

  Future<void> onReceiveMessagePressed() async {
    setState(() => busy = true);
    final m = await gpioController.serialReceive();
    setState(() {
      serialMessage = m ?? '';
      busy = false;
    });
  }
}

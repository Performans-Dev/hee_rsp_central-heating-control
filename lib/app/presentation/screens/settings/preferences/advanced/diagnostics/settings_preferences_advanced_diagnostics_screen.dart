import 'package:central_heating_control/app/data/services/gpio.dart';
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
    return GetBuilder<GpioController>(builder: (gpio) {
      Widget serialConsoleWidget = Row(
        children: [
          Expanded(
            child: TextInputWidget(
              controller: serialInputController,
              labelText: gpio.serialKey,
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
              ElevatedButton(
                  onPressed: () async {
                    setState(() => txOpenResult = 'Opening...');
                    final s = await gpio.txOpen();
                    setState(() => txOpenResult = s);
                  },
                  child: const Text('Open TX')),
              Text('TX OPEN RESULT: $txOpenResult'),
              ElevatedButton(
                  onPressed: () async {
                    setState(() => txCloseResult = 'Closing...');
                    final s = await gpio.txClose();
                    setState(() => txCloseResult = s);
                  },
                  child: const Text('Close TX')),
              Text('TX CLOSE RESULT: $txCloseResult'),
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

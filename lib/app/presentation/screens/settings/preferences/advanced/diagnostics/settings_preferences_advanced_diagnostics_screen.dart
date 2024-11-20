import 'package:central_heating_control/app/data/services/state_controller.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesAdvancedDiagnosticsScreen extends StatelessWidget {
  const SettingsPreferencesAdvancedDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(
      builder: (sc) {
        return GetBuilder<StateController>(
          builder: (sc) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Diagnostics'),
              ),
              body: PiScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...sc.outputChannels.map((e) => Text(e.toString())),
                    const Divider(),
                    ...sc.inputChannels.map((e) => Text(e.toString())),
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

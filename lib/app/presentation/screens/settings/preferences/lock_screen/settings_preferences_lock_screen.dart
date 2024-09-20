import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/string.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesLockScreen extends StatefulWidget {
  const SettingsPreferencesLockScreen({super.key});

  @override
  State<SettingsPreferencesLockScreen> createState() =>
      _SettingsPreferencesLockScreenState();
}

class _SettingsPreferencesLockScreenState
    extends State<SettingsPreferencesLockScreen> {
  late int selectedIdleTimeout;
  @override
  void initState() {
    super.initState();
    selectedIdleTimeout =
        Box.getInt(key: Keys.idleTimerInSeconds, defaultVal: 60);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Lock Screen',
      selectedIndex: 3,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: PiScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Kilit Ekranı Süresi'),
                  Slider(
                    value: selectedIdleTimeout.toDouble(),
                    onChanged: (value) {
                      setState(() => selectedIdleTimeout = value.toInt());
                    },
                    min: 15.0,
                    max: 300.0,
                    divisions: 57,
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          actionButton,
        ],
      ),
    );
  }

  Widget get actionButton => Container(
        // color: Theme.of(context).focusColor,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel")),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                await Box.setInt(
                    key: Keys.idleTimerInSeconds, value: selectedIdleTimeout);
                Get.back();
              },
              child: const Text("Confirm"),
            ),
          ],
        ),
      );
}

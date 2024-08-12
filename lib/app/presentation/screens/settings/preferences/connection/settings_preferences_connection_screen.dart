import 'dart:io';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/string.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';

class SettingsPreferencesConnectionScreen extends StatefulWidget {
  const SettingsPreferencesConnectionScreen({super.key});

  @override
  State<SettingsPreferencesConnectionScreen> createState() =>
      _SettingsPreferencesConnectionScreenState();
}

class _SettingsPreferencesConnectionScreenState
    extends State<SettingsPreferencesConnectionScreen> {
  late TextEditingController ssidController;
  late TextEditingController passController;
  List<String> wifiSSids = [];
  bool isScanning = false;
  String selectedSsid = '';

  @override
  void initState() {
    super.initState();
    ssidController = TextEditingController();
    passController = TextEditingController();
    ssidController.text = Box.getString(key: 'wifiSsid');
    passController.text = Box.getString(key: 'wifiPassword');
    selectedSsid = Box.getString(key: Keys.wifiSsid);
    _fetchWifiSsids();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Connection',
      selectedIndex: 3,
      body: PiScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text('WiFi'.tr),
            Row(
              children: [
                Expanded(
                  child: wifiSSids.length > 1
                      ? StringDropdownWidget(
                          data: wifiSSids,
                          value: selectedSsid,
                          onChanged: (value) {
                            setState(() {
                              selectedSsid = value ?? '';
                            });
                          },
                        )
                      : TextInputWidget(
                          labelText: 'Wifi SSID',
                          controller: ssidController,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextInputWidget(
                    labelText: 'Wifi Password',
                    controller: passController,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    var ssid = selectedSsid.isEmpty
                        ? ssidController.text
                        : selectedSsid;
                    var password = passController.text;
                    await Box.setString(key: Keys.wifiSsid, value: ssid);
                    await Box.setString(key: Keys.wifiPass, value: password);
                    final connectionStatus = await CommonUtils.connectToWifi(
                      wifiSsid: ssid,
                      wifiPassword: password,
                    );
                    if (context.mounted) {
                      if (connectionStatus.exitCode == 0) {
                        DialogUtils.snackbar(
                            context: context,
                            message: 'Connected',
                            type: SnackbarType.success);
                      } else {
                        DialogUtils.snackbar(
                            context: context,
                            message: 'Cannot connect',
                            type: SnackbarType.error);
                      }
                    }
                  },
                  child: Text('Save'.tr),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchWifiSsids() async {
    setState(() {
      wifiSSids.clear();
    });
    try {
      var shell = Shell();
      var result = await shell.run('nmcli -t -f SSID dev wifi');

      setState(() {
        wifiSSids = result.outText
            .split('\n')
            .where((ssid) => ssid.isNotEmpty)
            .toList();
      });
    } on Exception catch (_) {}
  }
}

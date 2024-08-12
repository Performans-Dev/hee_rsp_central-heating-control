import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
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
  late TextEditingController passController;
  late TextEditingController ipController;
  List<String> wifiSSids = [];
  bool isScanning = false;
  String selectedSsid = '';
  int isEthernetAuto = 0;
  bool isTesting = false;

  @override
  void initState() {
    super.initState();
    passController = TextEditingController();
    ipController = TextEditingController();
    passController.text = Box.getString(key: Keys.wifiPass);
    ipController.text = Box.getString(key: Keys.ethIpAddress);

    _fetchWifiSsids();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
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
                    child: wifiSSids.length > 0
                        ? StringDropdownWidget(
                            data: wifiSSids,
                            value: selectedSsid,
                            onChanged: (value) {
                              setState(() {
                                selectedSsid = value ?? '';
                              });
                            },
                          )
                        : Text('Scanning WiFi'),
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
                      final ssid = selectedSsid;
                      final password = passController.text;
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
              const Divider(),
              const SizedBox(height: 12),
              Text('Ethernet'.tr),
              const SizedBox(height: 12),
              RadioListTile(
                shape:
                    RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
                value: 0,
                groupValue: isEthernetAuto,
                onChanged: (val) {
                  setState(() {
                    isEthernetAuto = val ?? 0;
                  });
                },
                selected: isEthernetAuto == 0,
                title: const Text('Automatic IP address'),
                secondary:
                    isEthernetAuto == 0 ? const Text('Obtain from DHCP') : null,
              ),
              Container(
                height: 64,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: RadioListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: UiDimens.formRadius),
                        value: 1,
                        groupValue: isEthernetAuto,
                        onChanged: (val) {
                          setState(() {
                            isEthernetAuto = val ?? 1;
                          });
                        },
                        selected: isEthernetAuto == 1,
                        title: const Text('Manuel IP address'),
                      ),
                    ),
                    if (isEthernetAuto == 1)
                      Expanded(
                        flex: 1,
                        child: TextInputWidget(
                          labelText: 'IP Address',
                          maxLenght: 15,
                          minLength: 7,
                          controller: ipController,
                          hintText: '0.0.0.0',
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Save'.tr),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isTesting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      : app.didConnected
                          ? app.networkIndicator == NetworkIndicator.ethernet
                              ? const Icon(
                                  Icons.lan_outlined,
                                  color: Colors.green,
                                )
                              : app.networkIndicator == NetworkIndicator.wifi
                                  ? const Icon(Icons.wifi, color: Colors.green)
                                  : const Icon(Icons.wifi_off)
                          : const Icon(Icons.wifi_off),
                  Text(
                      'Type:\n${isTesting ? '-' : app.networkIndicator.name.camelCaseToHumanReadable()}'),
                  Text(
                    'Name:\n${isTesting ? '-' : app.networkName ?? '-'}',
                  ),
                  Text(
                    'IP:\n${isTesting ? '-' : app.networkIp}',
                  ),
                  Text(
                    'Gateway:\n${isTesting ? '-' : app.networkGateway}',
                  ),
                  ElevatedButton(
                    onPressed: isTesting
                        ? null
                        : () {
                            setState(() {
                              isTesting = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                isTesting = false;
                              });
                            });
                          },
                    child: Text(isTesting
                        ? 'Testing Connection...'
                        : 'Test Connection'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _fetchWifiSsids() async {
    setState(() {
      wifiSSids.clear();
    });
    try {
      var shell = Shell();
      var result = await shell.run('nmcli -t -f SSID dev wifi');
      var list =
          result.outText.split('\n').where((ssid) => ssid.isNotEmpty).toList();
      list.insert(0, '');
      setState(() {
        wifiSSids = list;
      });
      final previousSsid = Box.getString(key: Keys.wifiSsid);
      if (wifiSSids.contains(previousSsid)) {
        setState(() {
          selectedSsid = previousSsid;
        });
      }
    } on Exception catch (_) {
      setState(() {
        wifiSSids = ['', 'SampleSSID1', 'SampleSSID2'];
      });
    }
  }
}

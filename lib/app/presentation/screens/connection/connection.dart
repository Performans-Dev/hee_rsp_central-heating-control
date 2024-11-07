import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/components/dropdowns/string.dart';
import 'package:central_heating_control/app/presentation/widgets/label.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  late TextEditingController passController;

  late TextEditingController ipController;

  List<String> wifiSSids = [];

  bool isScanning = false;

  String selectedSsid = '';

  int isEthernetAuto = 0;

  bool isTesting = false;

  bool passwordVisible = false;
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
    return GetBuilder<SetupController>(builder: (sc) {
      return GetBuilder<AppController>(builder: (app) {
        return Scaffold(
          appBar: AppBar(title: const Text("Connection Settings")),
          body: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('WiFi'.tr),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.save),
                        onPressed: () async {
                          final ssid = selectedSsid;
                          final password = passController.text;
                          await Box.setString(key: Keys.wifiSsid, value: ssid);
                          await Box.setString(
                              key: Keys.wifiPass, value: password);
                          final connectionStatus =
                              await CommonUtils.connectToWifi(
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
                        label: Text('Save'.tr),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: wifiSSids.isNotEmpty
                            ? StringDropdownWidget(
                                data: wifiSSids,
                                value: selectedSsid,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSsid = value ?? '';
                                  });
                                },
                              )
                            : const Text('Scanning WiFi'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextInputWidget(
                          labelText: 'Wifi Password',
                          controller: passController,
                          obscureText: !passwordVisible,
                          showPasswordCallback: () {
                            setState(() => passwordVisible = !passwordVisible);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ethernet'.tr),
                      Container(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.save),
                          onPressed: () {},
                          label: Text('Save'.tr),
                        ),
                      ),
                    ],
                  ),
                  RadioListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: UiDimens.formRadius),
                    value: 0,
                    groupValue: isEthernetAuto,
                    onChanged: (val) {
                      setState(() {
                        isEthernetAuto = val ?? 0;
                      });
                    },
                    selected: isEthernetAuto == 0,
                    title: const Text('Automatic IP address'),
                    secondary: isEthernetAuto == 0
                        ? const Text('Obtain from DHCP')
                        : null,
                  ),
                  SizedBox(
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
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text('Status'.tr),
                          isTesting
                              ? const SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: CircularProgressIndicator(),
                                )
                              : app.didConnected
                                  ? app.networkIndicator ==
                                          NetworkIndicator.ethernet
                                      ? const Icon(
                                          Icons.lan_outlined,
                                          color: Colors.green,
                                          size: 36,
                                        )
                                      : app.networkIndicator ==
                                              NetworkIndicator.wifi
                                          ? const Icon(
                                              Icons.wifi,
                                              color: Colors.green,
                                              size: 36,
                                            )
                                          : const Icon(
                                              Icons.wifi_off,
                                              size: 36,
                                            )
                                  : const Icon(
                                      Icons.wifi_off,
                                      size: 36,
                                    ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Text(
                          'Type:\n${isTesting ? '-' : app.networkIndicator.name.camelCaseToHumanReadable()}'),
                      const SizedBox(width: 20),
                      Text(
                        'Name:\n${isTesting ? '-' : app.networkName ?? '-'}',
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'IP:\n${isTesting ? '-' : app.networkIp}',
                      ),
                      const SizedBox(width: 20),
                      Text(
                        'Gateway:\n${isTesting ? '-' : app.networkGateway}',
                      ),
                      const Spacer(),
                      SizedBox(
                        height: kToolbarHeight,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.check),
                          onPressed: isTesting
                              ? null
                              : () {
                                  setState(() {
                                    isTesting = true;
                                  });
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    setState(() {
                                      isTesting = false;
                                    });
                                    if (app.didConnected) Get.back();
                                  });
                                },
                          label: Text(isTesting
                              ? 'Testing Connection...'
                              : 'Test Connection'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
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

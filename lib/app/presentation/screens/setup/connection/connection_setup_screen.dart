import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/connection_card.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:process_run/shell.dart';

enum SetupConnectionState {
  none,
  checkingEth,
  checkingWifi,
  wifiForm,
  connected,
  notConnected,
}

class SetupConnectionScreen extends StatefulWidget {
  const SetupConnectionScreen({super.key});

  @override
  State<SetupConnectionScreen> createState() => _SetupConnectionScreenState();
}

class _SetupConnectionScreenState extends State<SetupConnectionScreen> {
  late TextEditingController _passwordController;
  late Timer timer;
  SetupConnectionState screenState = SetupConnectionState.none;
  final AppController appController = Get.find();
  String title = "";
  String selectedSsid = "";
  List<String> _wifiSsids = [];
  bool retryButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    // initTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        Widget widget = Container();
        switch (screenState) {
          case SetupConnectionState.none:
            widget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  "Hangi yöntem ile bağlanmak istiyorsunuz?",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ConnectionCardWidget(
                        text: "Wifi",
                        onTap: () {
                          setState(
                            () {
                              screenState = SetupConnectionState.wifiForm;
                            },
                          );
                          _fetchWifiSsids();
                        },
                        icon: Icons.wifi),
                    ConnectionCardWidget(
                        text: "Ethernet",
                        onTap: () {
                          setState(() {
                            screenState = SetupConnectionState.checkingEth;
                          });
                          startTimer();
                        },
                        icon: Icons.lan),
                  ],
                )
              ],
            );
            title = "Bağlantı tipi seçiniz";
            break;
          case SetupConnectionState.checkingEth:
            widget = loadingWidget;
            title = " Ethernet bağlantısı kontrol ediliyor";
            break;
          case SetupConnectionState.checkingWifi:
            widget = loadingWidget;
            title = " Wifi bağlantısı kontrol ediliyor";
            break;
          case SetupConnectionState.wifiForm: // ssid paswword kutusu
            widget = selectedSsid.isEmpty
                ? _wifiSsids.isEmpty
                    ? loadingWidget
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: _wifiSsids.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(_wifiSsids[index]),
                                  onTap: () {
                                    setState(() {
                                      selectedSsid = _wifiSsids[index];
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                  label:
                                      const Text("Bağlantı yöntemini değiştir"),
                                  onPressed: () {
                                    setState(() {
                                      screenState = SetupConnectionState.none;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_back)),
                              TextButton.icon(
                                  label: const Text("WiFi listesini yenile"),
                                  onPressed: () {
                                    _fetchWifiSsids();
                                  },
                                  icon: const Icon(Icons.refresh)),
                            ],
                          ),
                        ],
                      )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          selectedSsid,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                              label: const Text("Bağlantı yöntemini değiştir"),
                              onPressed: () {
                                setState(() {
                                  screenState = SetupConnectionState.none;
                                });
                              },
                              icon: const Icon(Icons.arrow_back)),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedSsid = "";
                                });
                              },
                              child: const Text("Başka bir ağı seç"))
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextInputWidget(
                              controller: _passwordController,
                              labelText: 'WIFI Password',
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _passwordController.text.isNotEmpty
                                ? () async {
                                    //ssid şifre diske yaz
                                    // işletim sistemine bağlan komutu gönder
                                    // Save WiFi credentials and initiate connection check
                                    setState(() {
                                      screenState =
                                          SetupConnectionState.checkingWifi;
                                    });
                                    final result =
                                        await saveCredentialsAndConnect();
                                    print(result);
                                    checkNetwork(autotrigger: false);
                                  }
                                : null,
                            child: const Text("Kaydet ve Bağlan"),
                          ),
                        ],
                      ),
                    ],
                  );

            /*       Column(
              children: [
                TextInputWidget(
                  controller: _ssidController,
                  labelText: 'WIFI SSID',
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
            
              ],
            ); */
            title = selectedSsid.isEmpty
                ? "WiFi ağı seçin"
                : "WiFi şifresini girin";
            break;
          case SetupConnectionState.connected:
            widget = const SizedBox(
              height: 250,
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 48,
                ),
              ),
            );
            title = "Bağlandı";
            break;
          case SetupConnectionState.notConnected:
            widget = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                TextButton.icon(
                    label: const Text("Bağlantı yöntemini değiştir"),
                    onPressed: () {
                      setState(() {
                        screenState = SetupConnectionState.none;
                      });
                    },
                    icon: const Icon(Icons.arrow_back)),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      retryConnection();
                    },
                    child: const Text("Tekrar Dene"),
                  ),
                ),
              ],
            );
            title = "Bağlantı sağlanamadı";
            break;
        }
        return SetupScaffold(
          label: 'Connection'.tr,
          previousCallback: () {
            Get.toNamed(Routes.setupDateFormat);
          },
          nextCallback: SetupConnectionState.connected == screenState
              ? () async {
                  NavController.toHome();
                }
              : null,
          progressValue: 4 / 9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                title.tr,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              widget,
            ],
          ),
        );
      },
    );
  }

  startTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    checkNetwork(autotrigger: false);
  }

  checkNetwork({bool autotrigger = true}) {
    setState(() {
      screenState = appController.didConnected
          ? SetupConnectionState.connected
          : autotrigger
              ? SetupConnectionState.none
              : SetupConnectionState.notConnected;
    });
  }

  void retryConnection() async {
    setState(() {
      screenState = SetupConnectionState.checkingWifi;
    });
    await Future.delayed(const Duration(seconds: 3));
    checkNetwork(autotrigger: false);
  }

  Future<ProcessResult> saveCredentialsAndConnect() async {
    String password = _passwordController.text;

    await saveCredentials(selectedSsid, password);

    return await connectToWifi();
  }

  Future<ProcessResult> connectToWifi() async {
    //TODO: TEKRAR BAK ÇALIŞIYOR MU CİHAZDA DENE.
    return await Process.run('nmcli', [
      'd',
      'wifi',
      'connect',
      selectedSsid,
      'password',
      _passwordController.text
    ]);
  }

  Future<void> saveCredentials(String ssid, String password) async {
    final box = GetStorage();
    await box.write("ssid", ssid);
    await box.write("password", password);
  }

  Future<void> _fetchWifiSsids() async {
    setState(() {
      _wifiSsids.clear();
    });
    var shell = Shell();
    var result = await shell.run('nmcli -t -f SSID dev wifi');

    setState(() {
      _wifiSsids =
          result.outText.split('\n').where((ssid) => ssid.isNotEmpty).toList();
    });
  }

  Widget get loadingWidget => SizedBox(
        height: 250,
        width: double.infinity,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: LinearProgressIndicator(
              borderRadius: UiDimens.formRadius,
            ),
          ),
        ),
      );
}

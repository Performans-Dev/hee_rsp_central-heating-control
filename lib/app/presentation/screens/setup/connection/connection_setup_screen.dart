import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:process_run/shell.dart';

enum SetupConnectionState {
  none,
  checkingEth,
  checkingWifi,
  wifiForm,
  connected,
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
                    cardWidget("Wifi", () {
                      setState(
                        () {
                          screenState = SetupConnectionState.wifiForm;
                        },
                      );
                      _fetchWifiSsids();
                    }, Icons.wifi),
                    cardWidget("Ethernet", () {
                      setState(() {
                        screenState = SetupConnectionState.checkingEth;
                      });
                      startTimer();
                    }, Icons.lan),
                  ],
                )
              ],
            );
            title = "Bağlantınız yok";
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
                    ? const Center(child: CircularProgressIndicator())
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
                                  label: const Text("WIFI listesini yenile"),
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
                                ? () {
                                    //ssid şifre diske yaz
                                    // işletim sistemine bağlan komutu gönder
                                    // Save WiFi credentials and initiate connection check
                                    saveCredentialsAndConnect();
                                    setState(() {
                                      screenState =
                                          SetupConnectionState.checkingWifi;
                                    });
                                    startTimer();
                                  }
                                : null,
                            child: const Text("Kaydet ve Bağlan"),
                          ),
                        ],
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
            title = "WiFi şifresini girin";
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
        }
        return SetupScaffold(
          label: 'Connection'.tr,
          previousCallback: () {
            Get.toNamed(Routes.setupDateFormat);
          },
          nextCallback: SetupConnectionState.connected == screenState
              ? () async {
                  Get.toNamed(Routes.home);
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

  startTimer() {
    timer = Timer(const Duration(seconds: 3), checkNetwork);
  }

  checkNetwork() {
    setState(() {
      screenState = appController.didConnected
          ? SetupConnectionState.connected
          : SetupConnectionState.none;
    });
  }

  Future<void> saveCredentialsAndConnect() async {
    String password = _passwordController.text;

    await saveCredentials(selectedSsid, password);

    await connectToWifi();
  }

  Future<void> connectToWifi() async {
    //TODO: TEKRAR BAK ÇALIŞIYOR MU CİHAZDA DENE.
    await Process.run('nmcli', [
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
    var shell = Shell();
    var result = await shell.run('nmcli -t -f SSID dev wifi');

    setState(() {
      _wifiSsids =
          result.outText.split('\n').where((ssid) => ssid.isNotEmpty).toList();
    });
  }

  Widget cardWidget(String text, Function()? onTap, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        hoverColor: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 150, minHeight: 100),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.67,
                child: Icon(
                  icon,
                  size: 48,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get loadingWidget => SizedBox(
        height: 250,
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

import 'dart:async';
import 'dart:io';

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Timer timer;
  SetupConnectionState screenState = SetupConnectionState.none;
  final AppController appController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initTimer();
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
                Text(
                  "Bağlantınız yok",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  "Hangi yöntem ile bağlanmak istiyorsunuz?",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    cardWidget(
                        "Wifi",
                        () => setState(
                              () {
                                screenState = SetupConnectionState.wifiForm;
                              },
                            ),
                        Icons.wifi),
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

            break;
          case SetupConnectionState.checkingEth:
            widget = loadingWidget;
            break;
          case SetupConnectionState.checkingWifi:
            widget = loadingWidget;
            break;
          case SetupConnectionState.wifiForm: // ssid paswword kutusu
            widget = Column(
              children: [
                TextField(
                  controller: _ssidController,
                  decoration: const InputDecoration(
                    labelText: 'WiFi SSID',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'WiFi Password',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    //ssid şifre diske yaz
                    // işletim sistemine bağlan komutu gönder
                    // Save WiFi credentials and initiate connection check
                    saveCredentialsAndConnect();
                    setState(() {
                      screenState = SetupConnectionState.checkingWifi;
                    });
                    startTimer();
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
            break;
          case SetupConnectionState.connected: // okey ikonu
            widget = const SizedBox(
              child: Text("connected"),
            );
            break;
        }
        return SetupScaffold(
          label: 'Connection'.tr,
          previousCallback: () {
            Get.toNamed(Routes.setupDateFormat);
          },
          nextCallback: () async {
            //save dateformat
            Get.toNamed(Routes.home);
          },
          progressValue: 4 / 9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Connect your Central Heating Control'.tr,
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
    String ssid = _ssidController.text;
    String password = _passwordController.text;

    await saveCredentials(ssid, password);

    await connectToWifi();
  }

  Future<void> connectToWifi() async {
    await Process.run('nmcli', [
      'd',
      'wifi',
      'connect',
      _ssidController.text,
      'password',
      _passwordController.text
    ]);
  }

  Future<void> saveCredentials(String ssid, String password) async {
    final box = GetStorage();
    await box.write("ssid", ssid);
    await box.write("password", password);
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
          constraints: BoxConstraints(minWidth: 150, minHeight: 100),
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
              SizedBox(
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

  Widget get loadingWidget => Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 10),
        child: LinearProgressIndicator(
          borderRadius: UiDimens.formRadius,
          color: Theme.of(context).indicatorColor,
        ),
      );
}

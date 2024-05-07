import 'package:central_heating_control/app/core/utils/device.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterDeviceScreen extends StatefulWidget {
  const RegisterDeviceScreen({super.key});

  @override
  State<RegisterDeviceScreen> createState() => _RegisterDeviceScreenState();
}

class _RegisterDeviceScreenState extends State<RegisterDeviceScreen> {
  final NavController nav = Get.find();
  final AppController appController = Get.find();
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    registerDevice();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                height: 300,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registering Hardware'.tr,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    Expanded(
                        child: Center(
                      child: isBusy
                          ? const CircularProgressIndicator()
                          : app.chcDeviceId == null
                              ? const Text('error')
                              : const Text('Please wait'),
                    ))
                  ],
                ),
              ),
            ),
            const StackTopLeftWidget(child: LogoWidget(size: 180)),
            const StackTopRightWidget(child: Text('Initial Setup 4 / 4')),
          ],
        ),
      );
    });
  }

  Future<void> registerDevice() async {
    setState(() {
      isBusy = true;
    });

    ChcDevice device = await DeviceUtils.createDeviceInfo();
    final response = await appController.registerDevice(device);
    setState(() {
      isBusy = false;
    });

    if (response == null) {
      logger.d('error');
    } else {
      nav.toHome();
    }
  }
}

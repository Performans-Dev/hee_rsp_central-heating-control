import 'package:central_heating_control/app/core/utils/device.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
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
      return SetupScaffold(
        progressValue: 5 / 8,
        label: 'Register Device'.tr,
        previousCallback: () {
          Get.toNamed(Routes.setupTimezone);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              'Registering Hardware'.tr,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            Container(
              height: 250,
              width: double.infinity,
              child: Center(
                child: isBusy
                    ? const CircularProgressIndicator()
                    : app.chcDeviceId == null
                        ? const Text('error')
                        : const Text('Please wait'),
              ),
            )
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
      NavController.toHome();
    }
  }
}

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashDeviceInfoScreen extends StatefulWidget {
  const SplashDeviceInfoScreen({super.key});

  @override
  State<SplashDeviceInfoScreen> createState() => _SplashDeviceInfoScreenState();
}

class _SplashDeviceInfoScreenState extends State<SplashDeviceInfoScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    await appController.readDevice();
    NavController.toHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingIndicatorWidget(
          text: 'Checking Device'.tr,
        ),
      ),
    );
  }
}

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashStructureAndProvisionCheckScreen extends StatefulWidget {
  const SplashStructureAndProvisionCheckScreen({super.key});

  @override
  State<SplashStructureAndProvisionCheckScreen> createState() =>
      _SplashStructureAndProvisionCheckScreenState();
}

class _SplashStructureAndProvisionCheckScreenState
    extends State<SplashStructureAndProvisionCheckScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  runInitTask() async {
    final AppController appController = Get.find();
    if (appController.didCheckFolders &&
        appController.didCheckedProvisionResults &&
        appController.didReadDeviceInfoCompleted) {
      NavController.toHome();
    } else {
      Future.delayed(
        const Duration(milliseconds: 10),
        () {
          runInitTask();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingIndicatorWidget(
          text: 'Checking Structure'.tr,
        ),
      ),
    );
  }
}

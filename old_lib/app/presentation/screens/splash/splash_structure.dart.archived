// ignore_for_file: avoid_print

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
  int counter = 0;

  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  runInitTask() async {
    final AppController appController = Get.find();
    print('--- $counter%');
    print('didCheckFolders: ${appController.didCheckFolders}');
    print(
        'didCheckedProvisionResults: ${appController.didCheckedProvisionResults}');
    print(
        'didReadDeviceInfoCompleted: ${appController.didReadDeviceInfoCompleted}');
    print('---');
    if (
        // appController.didCheckFolders &&
        //   appController.didCheckedProvisionResults &&

        appController.didReadDeviceInfoCompleted) {
      NavController.toHome();
    } else {
      setState(() => counter++);
      if (counter == 40) {
        appController.readDevice();
      }
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          runInitTask();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [Text('$counter%')]),
      body: Center(
        child: LoadingIndicatorWidget(
          text: 'Checking Structure'.tr,
        ),
      ),
    );
  }
}

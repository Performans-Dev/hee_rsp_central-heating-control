import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceRegisterDeviceScreen extends StatefulWidget {
  const SetupSequenceRegisterDeviceScreen({super.key});

  @override
  State<SetupSequenceRegisterDeviceScreen> createState() =>
      _SetupSequenceRegisterDeviceScreenState();
}

class _SetupSequenceRegisterDeviceScreenState
    extends State<SetupSequenceRegisterDeviceScreen> {
  final AppController appController = Get.find();
  final SetupController setupController = Get.find();
  bool error = false;
  bool initTaskIsRunning = false;

  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  @override
  Widget build(BuildContext context) {
    return SetupLayout(
      title: 'Register Device'.tr,
      isExpanded: true,
      child: Center(
        child: error
            ? Center(
                child: ElevatedButton(
                  onPressed: runInitTask,
                  child: Text(
                    'Retry',
                  ),
                ),
              )
            : LoadingIndicatorWidget(text: 'Registering Device...'.tr),
      ),
    );
  }

  Future<void> runInitTask() async {
    if (initTaskIsRunning) {
      return;
    }
    setState(() {
      error = false;
      initTaskIsRunning = true;
    });
    await appController.readDevice();
    if (appController.deviceInfo == null) {
      if (mounted) {
        DialogUtils.alertDialog(
          context: context,
          title: 'Error',
          description: 'Beklenmeyen bir hata olustu',
          positiveText: 'Tekrar Dene',
          positiveCallback: runInitTask,
        );
      }
      return;
    }
    final response =
        await appController.registerDevice(appController.deviceInfo!);
    if (mounted) {
      setState(() {
        initTaskIsRunning = false;
      });
    }
    if (response.success) {
      await Box.setBool(key: Keys.didRegisteredDevice, value: true);
      setupController.refreshSetupSequenceList();
      NavController.toHome();
    } else {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
    }
  }
}

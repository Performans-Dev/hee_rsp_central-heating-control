import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceActivationScreen extends StatefulWidget {
  const SetupSequenceActivationScreen({super.key});

  @override
  State<SetupSequenceActivationScreen> createState() =>
      _SetupSequenceActivationScreenState();
}

class _SetupSequenceActivationScreenState
    extends State<SetupSequenceActivationScreen> {
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
      title: 'Activation'.tr,
      isExpanded: true,
      child: Center(
        child: error
            ? ElevatedButton(
                onPressed: runInitTask,
                child: Text('Retry'),
              )
            : LoadingIndicatorWidget(
                text: 'Activating...'.tr,
              ),
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
    final account = Box.account;
    final deviceId = appController.deviceInfo?.id ?? '';
    final response = await appController.performActivation(
      deviceId: deviceId,
      accountId: account?.id ?? '',
    );
    if (mounted) {
      setState(() {
        initTaskIsRunning = false;
      });
    }
    if (response.success) {
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

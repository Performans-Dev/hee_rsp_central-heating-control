import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/__temp/_setup/setup_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceRegisterDeviceSection extends StatefulWidget {
  const SetupSequenceRegisterDeviceSection({super.key});

  @override
  State<SetupSequenceRegisterDeviceSection> createState() =>
      _SetupSequenceRegisterDeviceSectionState();
}

class _SetupSequenceRegisterDeviceSectionState
    extends State<SetupSequenceRegisterDeviceSection> {
  final AppController appController = Get.find();
  final SetupController setupController = Get.find();
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupScaffold(
              progressValue: sc.progress,
              label: 'Language'.tr,
              expandChild: true,
              child: Center(
                child: isBusy
                    ? LoadingIndicatorWidget(text: 'Registering Device...'.tr)
                    : Text('Registering Device...'.tr),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> runInitTask() async {
    setState(() => isBusy = true);
    await appController.readDevice();
    if (appController.deviceInfo == null) {
      setState(() => isBusy = false);
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
    setState(() => isBusy = false);
    if (response.success) {
      setupController.refreshSetupSequenceList();
      NavController.toHome();
    } else {
      Future.delayed(
        Duration(seconds: 1),
        () {
          runInitTask();
        },
      );
    }
  }
}

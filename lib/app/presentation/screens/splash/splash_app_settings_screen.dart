import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashAppSettingsScreen extends StatefulWidget {
  const SplashAppSettingsScreen({super.key});

  @override
  State<SplashAppSettingsScreen> createState() =>
      _SplashAppSettingsScreenState();
}

class _SplashAppSettingsScreenState extends State<SplashAppSettingsScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();

    var result = await appController.fetchAppSettings();
    if (result) {
      NavController.toHome();
    } else {
      if (mounted) {
        DialogUtils.confirmDialog(
          context: context,
          title: "Connection Error".tr,
          description: "Failed to connect to the server".tr,
          positiveText: "Open Connection Settings",
          negativeText: "Retry".tr,
          negativeCallback: runInitTask,
          positiveCallback: () async {
            await Get.toNamed(Routes.connection);
            runInitTask();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingIndicatorWidget(
          text: 'Loading Settings'.tr,
        ),
      ),
    );
  }
}

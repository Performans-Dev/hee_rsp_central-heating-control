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
/*     if (!appController.didConnected) {
      NavController.toConnection();
      return;
    } */
    await appController.fetchAppSettings();
    NavController.toHome();
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

/* import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashInternetConnectionProgressScreen extends StatefulWidget {
  const SplashInternetConnectionProgressScreen({super.key});

  @override
  State<SplashInternetConnectionProgressScreen> createState() =>
      _MyWidgetState();
}

class _MyWidgetState extends State<SplashInternetConnectionProgressScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: LoadingIndicatorWidget(
        text: 'Checking Internet Connection'.tr,
      ),
    ));
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    if (appController.didConnectionChecked) {
      Get.offAndToNamed(Routes.splashAppSettings);
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        runInitTask();
      });
    }
  }
}
 */
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
  int progress = 0;

  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    if (appController.didReadDeviceInfoCompleted) {
      NavController.toHome();
    } else {
      setState(() => progress++);
      Future.delayed(const Duration(milliseconds: 10), () => runInitTask());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Text('$progress%')],
      ),
      body: Center(
        child: LoadingIndicatorWidget(
          text: 'Checking Device'.tr,
        ),
      ),
    );
  }
}

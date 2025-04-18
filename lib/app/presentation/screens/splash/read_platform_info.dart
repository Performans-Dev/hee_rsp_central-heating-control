import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashReadPlatformInfoScreen extends StatefulWidget {
  const SplashReadPlatformInfoScreen({super.key});

  @override
  State<SplashReadPlatformInfoScreen> createState() =>
      _SplashReadPlatformInfoScreenState();
}

class _SplashReadPlatformInfoScreenState
    extends State<SplashReadPlatformInfoScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    await appController.getPlatformInfo();
    if (appController.didReadPlatformInfoCompleted) {
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.offAllNamed(Routes.home);
      });
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        runInitTask();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            CircularProgressIndicator(),
            Text(
              'Reading Platform Info...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

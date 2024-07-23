import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashConnectionScreen extends StatefulWidget {
  const SplashConnectionScreen({super.key});

  @override
  State<SplashConnectionScreen> createState() => _SplashConnectionScreenState();
}

class _SplashConnectionScreenState extends State<SplashConnectionScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    if (!appController.connectivityResultReceived) {
      Future.delayed(Duration(seconds: 1), () {
        runInitTask();
      });
    } else {
      Get.offAllNamed(Routes.home);
    }
  }
}

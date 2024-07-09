import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/splash/splash_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashFetchSettingsScreen extends StatefulWidget {
  const SplashFetchSettingsScreen({super.key});

  @override
  State<SplashFetchSettingsScreen> createState() =>
      _SplashFetchSettingsScreenState();
}

class _SplashFetchSettingsScreenState extends State<SplashFetchSettingsScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  @override
  Widget build(BuildContext context) {
    return const SplashWidget(
      text: 'Fetching settings...',
    );
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    await appController.fetchSettings();
    Future.delayed(
      Duration.zero,
      () => NavController.toHome(),
    );
  }
}

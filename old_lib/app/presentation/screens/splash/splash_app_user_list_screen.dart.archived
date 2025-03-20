import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashAppUserListScreen extends StatefulWidget {
  const SplashAppUserListScreen({super.key});

  @override
  State<SplashAppUserListScreen> createState() =>
      _SplashAppUserListScreenState();
}

class _SplashAppUserListScreenState extends State<SplashAppUserListScreen> {
  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  Future<void> runInitTask() async {
    final AppController appController = Get.find();
    await appController.loadAppUserList();
    NavController.toHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingIndicatorWidget(
          text: 'Checking Users\n${Box.documentsDirectoryPath}'.tr,
        ),
      ),
    );
  }
}

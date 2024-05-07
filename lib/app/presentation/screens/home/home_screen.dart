import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/hardware_buttons.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return const Scaffold(
        appBar: HomeAppBar(),
        body: Stack(
          children: [
            Center(
              child: Text('zones'),
            ),
            HwBtnPowerToggle(),
            HwBtnWeeklyPlan(),
            HwBtnThemeToggle(),
            HwBtnSettings(),
            HwBtnUpArrow(),
            HwBtnDownArrow(),
            HwBtnCheck(),
            HwBtnCancel(),
          ],
        ),
      );
    });
  }
}

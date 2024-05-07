import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:central_heating_control/app/presentation/widgets/hardware_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        appBar: HomeAppBar(),
        body: Stack(
          children: [
            Center(
              child: Text('zones'),
            ),
            HwButton(
              location: HardwareButtonLocation.l0,
              child: Icon(Icons.power_settings_new),
              callback: () {},
              enabled: true,
              visible: true,
            ),
            HwButton(
              location: HardwareButtonLocation.l1,
              child: Icon(Icons.alarm),
              callback: () {},
              enabled: true,
              visible: true,
            ),
            HwButton(
              location: HardwareButtonLocation.l2,
              child: Icon(app.isDarkMode ? Icons.dark_mode : Icons.sunny),
              callback: () {
                app.toggleDarkMode();
              },
              enabled: true,
              visible: true,
            ),
            HwButton(
              location: HardwareButtonLocation.l3,
              child: Icon(Icons.settings),
              callback: () {},
              enabled: true,
              visible: true,
            ),
            HwButton(
              location: HardwareButtonLocation.r0,
              child: Icon(Icons.arrow_upward),
              callback: () {},
              enabled: true,
              visible: false,
            ),
            HwButton(
              location: HardwareButtonLocation.r1,
              child: Icon(Icons.arrow_downward),
              callback: () {},
              enabled: true,
              visible: false,
            ),
            HwButton(
              location: HardwareButtonLocation.r2,
              child: Icon(Icons.check),
              callback: () {},
              enabled: true,
              visible: false,
            ),
            HwButton(
              location: HardwareButtonLocation.r3,
              child: Icon(Icons.close),
              callback: () {},
              enabled: true,
              visible: false,
            ),
          ],
        ),
      );
    });
  }
}

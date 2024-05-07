import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/widgets/hardware_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HwBtnPowerToggle extends StatelessWidget {
  const HwBtnPowerToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.l0,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.power_settings_new),
    );
  }
}

class HwBtnWeeklyPlan extends StatelessWidget {
  const HwBtnWeeklyPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.l1,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.alarm),
    );
  }
}

class HwBtnThemeToggle extends StatelessWidget {
  const HwBtnThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return HwButton(
        location: HardwareButtonLocation.l2,
        callback: () {
          app.toggleDarkMode();
        },
        enabled: true,
        visible: true,
        child: Icon(app.isDarkMode ? Icons.dark_mode : Icons.sunny),
      );
    });
  }
}

class HwBtnSettings extends StatelessWidget {
  const HwBtnSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.l3,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.settings),
    );
  }
}

class HwBtnUpArrow extends StatelessWidget {
  const HwBtnUpArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.r0,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.arrow_upward),
    );
  }
}

class HwBtnDownArrow extends StatelessWidget {
  const HwBtnDownArrow({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.r1,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.arrow_downward),
    );
  }
}

class HwBtnCheck extends StatelessWidget {
  const HwBtnCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.r2,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.check),
    );
  }
}

class HwBtnCancel extends StatelessWidget {
  const HwBtnCancel({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.r3,
      callback: () {},
      enabled: true,
      visible: true,
      child: const Icon(Icons.close),
    );
  }
}

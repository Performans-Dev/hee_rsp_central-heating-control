import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
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

class HwBtnHome extends StatelessWidget {
  const HwBtnHome({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.l0,
      callback: () {
        NavController.toHome();
      },
      enabled: true,
      visible: true,
      child: const Icon(Icons.home),
    );
  }
}

class HwBtnBack extends StatelessWidget {
  const HwBtnBack({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.l3,
      callback: () {
        Get.back();
      },
      enabled: true,
      visible: true,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back),
          SizedBox(width: 8),
          Text('Back'),
        ],
      ),
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
      callback: () {
        NavController.toSettings();
      },
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

class HwBtnAbort extends StatelessWidget {
  const HwBtnAbort({super.key});

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

class HwBtnAddUser extends StatelessWidget {
  const HwBtnAddUser({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.r3,
      callback: () => NavController.toSettingsAddUser(),
      enabled: true,
      visible: true,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add),
          SizedBox(width: 8),
          Text('Add New User'),
        ],
      ),
    );
  }
}

class HwBtnSave extends StatelessWidget {
  const HwBtnSave({super.key, this.callback, this.isPrimary = true});
  final GestureTapCallback? callback;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.r3,
      callback: callback,
      enabled: true,
      visible: true,
      isPrimary: isPrimary,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.save_alt),
          SizedBox(width: 8),
          Text('Save'),
        ],
      ),
    );
  }
}

class HwBtnCancel extends StatelessWidget {
  const HwBtnCancel({super.key});

  @override
  Widget build(BuildContext context) {
    return HwButton(
      location: HardwareButtonLocation.l3,
      callback: () {
        Get.back();
      },
      enabled: true,
      visible: true,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cancel),
          SizedBox(width: 8),
          Text('Cancel'),
        ],
      ),
    );
  }
}

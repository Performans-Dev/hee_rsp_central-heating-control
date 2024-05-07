import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/presentation/widgets/hardware_buttons.dart';
import 'package:flutter/material.dart';

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

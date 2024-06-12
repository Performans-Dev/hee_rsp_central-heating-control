import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:flutter/material.dart';

class CCUtils {
  static String displayConsumption(
      {double? consumptionAmount, String? consumptionUnit}) {
    if (consumptionAmount == null || consumptionUnit == null) {
      return 'N/A';
    }
    return '${consumptionAmount.toStringAsPrecision(1)} $consumptionUnit';
  }

  static String displayCarbon(double? carbonEmission) {
    if (carbonEmission == null) {
      return 'CO₂ emission not available';
    }
    return 'CO₂ emission ${carbonEmission.toStringAsPrecision(1)} kt';
  }

  static String stateDisplay(HeaterState s) {
    switch (s) {
      case HeaterState.off:
        return 'Off';
      case HeaterState.auto:
        return 'Auto';
      case HeaterState.level1:
        return 'On';
      case HeaterState.level2:
        return 'High';
      case HeaterState.level3:
        return 'Max';
    }
  }

  static String temperature(int t,
      {bool divideBy10 = true, int presicion = 1}) {
    return '${(t / (divideBy10 ? 10 : 1)).toStringAsFixed(presicion)}°';
  }

  static Color colorByLevel(int level) {
    switch (level) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

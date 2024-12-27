import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  static String stateDisplay(ControlMode mode) {
    switch (mode) {
      case ControlMode.off:
        return 'Off';
      case ControlMode.auto:
        return 'Auto';
      case ControlMode.on:
        return 'On';
      case ControlMode.high:
        return 'High';
      case ControlMode.max:
        return 'Max';
    }
  }

  static Color stateColor(ControlMode mode) {
    switch (mode) {
      case ControlMode.off:
        return Colors.grey;
      case ControlMode.auto:
        return Colors.blue;
      case ControlMode.on:
        return Colors.orange;
      case ControlMode.high:
        return Colors.deepOrange;
      case ControlMode.max:
        return Colors.red;
    }
  }

  static String temperature(
    int t, {
    bool divideBy10 = true,
    int presicion = 1,
  }) =>
      '${(t / (divideBy10 ? 10 : 1)).toStringAsFixed(presicion)}°';

  static Color colorByLevel(int level) {
    switch (level) {
      case 1:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static Widget stateIcon(ControlMode mode, {bool withColor = true}) {
    switch (mode) {
      case ControlMode.off:
        return FaIcon(
          FontAwesomeIcons.powerOff,
          color: withColor ? Colors.red : Colors.grey,
        );
      case ControlMode.auto:
        return FaIcon(
          FontAwesomeIcons.wandSparkles,
          color: withColor ? Colors.blue : Colors.grey,
        );

      case ControlMode.on:
        return FaIcon(
          FontAwesomeIcons.solidCircle,
          color: withColor ? Colors.orange : Colors.grey,
        );
      case ControlMode.high:
        return FaIcon(
          FontAwesomeIcons.solidCircle,
          color: withColor ? Colors.deepOrange : Colors.grey,
        );
      case ControlMode.max:
        return FaIcon(
          FontAwesomeIcons.solidCircle,
          color: withColor ? Colors.red : Colors.grey,
        );
    }
  }
}

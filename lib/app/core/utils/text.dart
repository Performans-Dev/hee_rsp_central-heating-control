import 'package:central_heating_control/app/core/constants/enums.dart';

class TextUtils {
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
        return 'Full';
    }
  }

  static String temperature(int t,
      {bool divideBy10 = true, int presicion = 1}) {
    return '${(t / (divideBy10 ? 10 : 1)).toStringAsFixed(presicion)}°';
  }
}

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
}

import 'dart:typed_data';

import 'package:flutter/material.dart';

class CommonUtils {
  static Color hexToColor(BuildContext context, String hex) {
    return hex.isEmpty
        ? Theme.of(context).canvasColor
        : Color(int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Uint8List stringToByte(String dataToSend) {
    List<int> dataAsCodeUnits = dataToSend.codeUnits;
    Uint8List dataAsBytes = Uint8List.fromList(dataAsCodeUnits);
    return dataAsBytes;
  }

  static String byteToString(Uint8List data) {
    String dataAsString = String.fromCharCodes(data);
    return dataAsString;
  }

  static String dayName(int i) {
    switch (i) {
      case 0:
        return 'MON';
      case 1:
        return 'TUE';
      case 2:
        return 'WED';
      case 3:
        return 'THU';
      case 4:
        return 'FRI';
      case 5:
        return 'SAT';
      case 6:
        return 'SUN';
      default:
        return '';
    }
  }
}

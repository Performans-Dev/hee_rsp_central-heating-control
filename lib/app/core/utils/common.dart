import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class CommonUtils {
  static String getCurrentDateFormatted() {
    final DateTime now = DateTime.now();
    final String formattedDate =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

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

  static bool isValidIPAddress(String ip) {
    // Regular expression for validating IPv4 addresses
    final ipv4Pattern = RegExp(
        r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');

    // Regular expression for validating IPv6 addresses
    final ipv6Pattern = RegExp(r'^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|'
        r'([0-9a-fA-F]{1,4}:){1,7}:|'
        r'([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
        r'([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|'
        r'([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|'
        r'([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|'
        r'([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|'
        r'[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|'
        r':((:[0-9a-fA-F]{1,4}){1,7}|:)|'
        r'fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|'
        r'::(ffff(:0{1,4}){0,1}:){0,1}'
        r'((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}'
        r'(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|'
        r'([0-9a-fA-F]{1,4}:){1,4}:'
        r'((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}'
        r'(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$');

    return ipv4Pattern.hasMatch(ip) || ipv6Pattern.hasMatch(ip);
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

  static Future<ProcessResult> connectToWifi({
    required String wifiSsid,
    required String wifiPassword,
  }) async {
    try {
      final result = await Process.run('nmcli', [
        'd',
        'wifi',
        'connect',
        wifiSsid,
        'password',
        wifiPassword,
      ]);
      return result;
    } on Exception catch (e) {
      return ProcessResult(0, -99, '', e.toString());
    }
  }

  static String secondsToHumanReadable(int seconds) {
    Duration duration = Duration(seconds: seconds);

    if (duration.inDays > 0) {
      return '${duration.inDays} gün ${duration.inHours.remainder(24)} saat ${duration.inMinutes.remainder(60)} dakika';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} saat ${duration.inMinutes.remainder(60)} dakika';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} dakika ${duration.inSeconds.remainder(60)} saniye';
    } else {
      return '${duration.inSeconds} saniye';
    }
  }
}

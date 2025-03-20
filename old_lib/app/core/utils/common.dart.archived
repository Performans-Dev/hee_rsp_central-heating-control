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

  static List<int> getCrcBytes(int value) {
    int firstByte = value % 256; // Remainder after dividing by 256
    int secondByte = value ~/ 256; // Integer division by 256
    return [firstByte, secondByte];
  }

  static int serialUartCrc16(Uint8List data) {
    const List<int> crcTable = [
      0x0000,
      0x1021,
      0x2042,
      0x3063,
      0x4084,
      0x50a5,
      0x60c6,
      0x70e7,
      0x8108,
      0x9129,
      0xa14a,
      0xb16b,
      0xc18c,
      0xd1ad,
      0xe1ce,
      0xf1ef
    ];

    int crc = 0xFFFF;

    for (int i = 0; i < data.length; i++) {
      int byte = data[i];
      crc = (crc << 4) ^ crcTable[((crc >> 12) ^ (byte >> 4)) & 0x0F];
      crc = (crc << 4) ^ crcTable[((crc >> 12) ^ (byte & 0x0F)) & 0x0F];
    }

    return crc & 0xFFFF;
  }

  static String bytesToHex(List<int> bytes) {
    return bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(' ')
        .toUpperCase();
  }

  static String uint8ListToHex(Uint8List bytes) {
    return bytesToHex(bytes.toList());
  }

  static Uint8List intListToUint8List(List<int> bytes) {
    return Uint8List.fromList(bytes);
  }

  static List<int> uint8ListToIntList(Uint8List bytes) {
    return bytes.toList();
  }

  static List<int> hexStringToBytes(List<String> hexStrings) {
    return hexStrings
        .map((hexString) => int.parse(hexString, radix: 16))
        .toList();
  }
}

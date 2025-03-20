import 'dart:typed_data';

class ByteUtils {
  static List<int> getCrcBytes(Uint8List data) {
    return getCrcBytesFromInt(serialUartCrc16(data));
  }

  static List<int> getCrcBytesFromInt(int value) {
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

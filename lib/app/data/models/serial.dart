import 'dart:typed_data';

import 'package:central_heating_control/app/core/utils/byte.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';

class SerialMessage {
  int device;
  int command;
  int index;
  int arg;
  SerialMessage({
    required this.device,
    required this.command,
    this.index = 0x00,
    this.arg = 0x00,
  });

  List<int> toBytesWithCrc() {
    // Create data array for CRC calculation (without placeholders)
    List<int> dataForCrc = [
      device,
      command,
      index,
      arg,
    ];

    // Calculate CRC only once using the actual data
    List<int> crcBytes = ByteUtils.getCrcBytes(Uint8List.fromList(dataForCrc));

    // Return complete message with start byte, data, CRC, and stop bytes
    return [
      startByte,
      device,
      command,
      index,
      arg,
      ...crcBytes,
      ...stopBytes,
    ];
  }

  Uint8List toBytes() => Uint8List.fromList(toBytesWithCrc());

  String toLog() => ByteUtils.bytesToHex(Uint8List.fromList(toBytesWithCrc()));
}

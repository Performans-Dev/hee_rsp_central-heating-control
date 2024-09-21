import 'dart:convert';

class SerialMessage {
  int deviceId;
  int command;
  int data1;
  int data2;
  SerialMessage({
    required this.deviceId,
    required this.command,
    this.data1 = 0x00,
    this.data2 = 0x00,
  });

  List<int> toBytes() {
    return [deviceId, command, data1, data2];
  }

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'command': command,
      'data1': data1,
      'data2': data2,
    };
  }

  factory SerialMessage.fromMap(Map<String, dynamic> map) {
    return SerialMessage(
      deviceId: map['deviceId']?.toInt() ?? 0,
      command: map['command']?.toInt() ?? 0,
      data1: map['data1']?.toInt() ?? 0,
      data2: map['data2']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SerialMessage.fromJson(String source) =>
      SerialMessage.fromMap(json.decode(source));
}

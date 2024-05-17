import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/models/dropdown.dart';

class ComPort {
  String id;
  String title;
  GpioPin pinNumber;
  GpioDirection direction;
  GpioGroup group;
  bool? available;
  ComPort({
    required this.id,
    required this.title,
    required this.pinNumber,
    required this.direction,
    required this.group,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'pinNumber': pinNumber.index,
      'direction': direction.index,
      'group': group.index,
    };
  }

  DropdownModel toDropdown() => DropdownModel(text: title, value: id);
  factory ComPort.fromMap(Map<String, dynamic> map) {
    return ComPort(
      id: map['id'] ?? '',
      title: map['title'] ?? 'N/A',
      pinNumber: GpioPin.values[map['pinNumber']?.toInt() ?? 0],
      direction: GpioDirection.values[map['direction']?.toInt() ?? 0],
      group: GpioGroup.values[map['group']?.toInt() ?? 0],
    );
  }

  String toJson() => json.encode(toMap());

  factory ComPort.fromJson(String source) =>
      ComPort.fromMap(json.decode(source));
}

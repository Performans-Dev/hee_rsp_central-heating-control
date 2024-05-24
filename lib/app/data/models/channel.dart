import 'dart:convert';

import 'package:central_heating_control/app/core/constants/enums.dart';

class Channel {
  String name;
  String id;
  GpioDirection direction;
  GpioGroup group;
  Channel({
    required this.name,
    required this.id,
    required this.direction,
    required this.group,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'direction': direction.index,
      'group': group.index,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      name: map['name'] ?? '',
      id: map['id'] ?? '',
      direction: GpioDirection.values[map['direction']],
      group: GpioGroup.values[map['group']],
    );
  }

  factory Channel.empty() => Channel(
      name: '---',
      id: '',
      direction: GpioDirection.none,
      group: GpioGroup.empty);

  String toJson() => json.encode(toMap());

  factory Channel.fromJson(String source) =>
      Channel.fromMap(json.decode(source));
}

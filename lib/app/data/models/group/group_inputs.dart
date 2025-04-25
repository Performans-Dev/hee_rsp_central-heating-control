import 'dart:convert';

import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';

class GroupInput {
  final int id;
  final int groupId;
  final DigitalInput digitalInput;
  final bool triggerValue;
  GroupInput({
    required this.id,
    required this.groupId,
    required this.digitalInput,
    required this.triggerValue,
  });

  GroupInput copyWith({
    int? id,
    int? groupId,
    DigitalInput? digitalInput,
    bool? triggerValue,
  }) {
    return GroupInput(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      digitalInput: digitalInput ?? this.digitalInput,
      triggerValue: triggerValue ?? this.triggerValue,
    );
  }

  Map<String, dynamic> toMap() {
    return id > 0
        ? {
            'id': id,
            'groupId': groupId,
            'digitalInputId': digitalInput.id,
            'triggerValue': triggerValue ? 1 : 0,
          }
        : {
            'groupId': groupId,
            'digitalInputId': digitalInput.id,
            'triggerValue': triggerValue ? 1 : 0,
          };
  }

  factory GroupInput.fromMap(Map<String, dynamic> map) {
    return GroupInput(
      id: map['id']?.toInt() ?? 0,
      groupId: map['groupId']?.toInt() ?? 0,
      digitalInput: DigitalInput.fromMap(map['digitalInput']),
      triggerValue: map['triggerValue'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupInput.fromJson(String source) =>
      GroupInput.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GroupInput(id: $id, groupId: $groupId, digitalInput: $digitalInput, triggerValue: $triggerValue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroupInput &&
        other.id == id &&
        other.groupId == groupId &&
        other.digitalInput.id == digitalInput.id &&
        other.triggerValue == triggerValue;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        groupId.hashCode ^
        digitalInput.id.hashCode ^
        triggerValue.hashCode;
  }
}

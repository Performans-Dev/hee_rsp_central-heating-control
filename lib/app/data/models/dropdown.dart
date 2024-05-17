// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DropdownModel {
  String text;
  dynamic value;
  DropdownModel({
    required this.text,
    required this.value,
  });

  DropdownModel copyWith({
    String? text,
    dynamic? value,
  }) {
    return DropdownModel(
      text: text ?? this.text,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'value': value,
    };
  }

  factory DropdownModel.fromMap(Map<String, dynamic> map) {
    return DropdownModel(
      text: map['text'] as String,
      value: map['value'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory DropdownModel.fromJson(String source) =>
      DropdownModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DropdownModel(text: $text, value: $value)';

  @override
  bool operator ==(covariant DropdownModel other) {
    if (identical(this, other)) return true;

    return other.text == text && other.value == value;
  }

  @override
  int get hashCode => text.hashCode ^ value.hashCode;
}

import 'dart:convert';

class TemperatureValue {
  String name;
  double temperature;
  double rawValue;
  TemperatureValue({
    required this.name,
    required this.temperature,
    required this.rawValue,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'temperature': temperature,
      'raw': rawValue,
    };
  }

  factory TemperatureValue.fromMap(Map<String, dynamic> map) {
    return TemperatureValue(
      name: map['name'] ?? "",
      temperature: map['temperature']?.toDouble(),
      rawValue: map['raw']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TemperatureValue.fromJson(String source) =>
      TemperatureValue.fromMap(json.decode(source));
}

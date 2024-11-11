class Sensor {
  final int id;
  final String name;
  final String color;
  final String zone;
  final String type;

  Sensor(
      {required this.id,
      required this.name,
      required this.color,
      required this.zone,
      required this.type});

  factory Sensor.fromMap(Map<String, dynamic> map) {
    return Sensor(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      zone: map['zone'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'color': color,
      'zone': zone,
      'type': type,
    };
  }
}

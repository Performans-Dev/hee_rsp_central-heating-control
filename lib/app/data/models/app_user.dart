import 'package:central_heating_control/app/core/constants/enums.dart';

class AppUser {
  int id;

  String username;
  String pin;
  AppUserLevel level;
  AppUser({
    required this.id,
    required this.username,
    required this.pin,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    if (id > 0) {
      return {
        'id': id,
        'username': username,
        'pin': pin,
        'level': level.value,
      };
    } else {
      return {
        'username': username,
        'pin': pin,
        'level': level.value,
      };
    }
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      pin: map['pin'] ?? '',
      level: AppUserLevel.values[map['level']?.toInt() ?? 0],
    );
  }
}

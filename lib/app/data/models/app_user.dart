import 'dart:convert';

class AppUser {
  
  String username;
  String pin;
  bool isAdmin;
  AppUser({
    required this.username,
    required this.pin,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'pin': pin,
      'isAdmin': isAdmin,
    };
  }

  Map<String, dynamic> toSQL() {
    return {
      'username': username,
      'pin': pin,
      'isAdmin': isAdmin ? 1 : 0,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      username: map['username'] ?? '',
      pin: map['pin'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  factory AppUser.fromSQL(Map<String, dynamic> map) {
    return AppUser(
      username: map['username'] ?? '',
      pin: map['pin'] ?? '',
      isAdmin: map['isAdmin'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));
}

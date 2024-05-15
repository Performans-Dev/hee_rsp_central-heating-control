import 'dart:convert';

class AppUser {
  int id;
  
  String username;
  String pin;
  bool isAdmin;
  AppUser({
    required this.id,
    required this.username,
    required this.pin,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
      return {
        'id': id,
        'username': username,
        'pin': pin,
        'isAdmin': isAdmin,
      };
  }

  Map<String, dynamic> toSQL() {
    if (id>0) {
    return {
      'id': id,
      'username': username,
      'pin': pin,
      'isAdmin': isAdmin ? 1 : 0,
    };
    }else{
       return {
      'username': username,
      'pin': pin,
      'isAdmin': isAdmin ? 1 : 0,
    };
    }
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? -1,
      username: map['username'] ?? '',
      pin: map['pin'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
    );
  }

  factory AppUser.fromSQL(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] ?? 0,
      username: map['username'] ?? '',
      pin: map['pin'] ?? '',
      isAdmin: map['isAdmin'] == 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source));
}

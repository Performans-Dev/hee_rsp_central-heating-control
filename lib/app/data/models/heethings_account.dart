// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HeethingsAccount {
  String id;
  String accessToken;
  String refreshToken;
  String? email;
  String? phoneNumber;
  String password; //passwordu tutmadan halledebiliyorsak silelim.
  int? subscriptionResult;
  String? subscriptionExpireDate;
  bool termsConsentStatus;
  bool privacyConsentStatus;
  HeethingsAccount({
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.password,
    this.subscriptionResult,
    this.subscriptionExpireDate,
    this.email,
    this.phoneNumber,
    this.termsConsentStatus = false,
    this.privacyConsentStatus = false,
  });
//login olunca appcontrollerdaki null olan account nesnesini yarat.
//subsresult null ise abonelik durumunu apiye sor cevabını güncelle.null ise ilerleyemecek.
//terms false ise terms göster privacy false ise privacy goster bunlar true olmadan ilerleyemecek.

  bool get isOkey =>
      id.isNotEmpty &&
      subscriptionResult != null &&
      termsConsentStatus &&
      privacyConsentStatus;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'subscriptionResult': subscriptionResult,
      'subscriptionExpireDate': subscriptionExpireDate,
      'termsConsentStatus': termsConsentStatus,
      'privacyConsentStatus': privacyConsentStatus,
    };
  }

  factory HeethingsAccount.fromMap(Map<String, dynamic> map) {
    return HeethingsAccount(
      id: (map['id'] ?? '') as String,
      accessToken: (map['accessToken'] ?? '') as String,
      refreshToken: (map['refreshToken'] ?? '') as String,
      email: map['email'] != null ? map['email'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      password: (map['password'] ?? '') as String,
      subscriptionResult: (map['subscriptionResult'] ?? 0) as int,
      subscriptionExpireDate:
          (map['subscriptionExpireDate'] ?? DateTime.now().toIso8601String()),
      termsConsentStatus: (map['termsConsentStatus'] ?? false) as bool,
      privacyConsentStatus: (map['privacyConsentStatus'] ?? false) as bool,
    );
  }
  String toJson() => json.encode(toMap());

  factory HeethingsAccount.fromJson(String source) =>
      HeethingsAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  HeethingsAccount copyWith({
    String? id,
    String? accessToken,
    String? refreshToken,
    String? email,
    String? phoneNumber,
    String? password,
    int? subscriptionResult,
    String? subscriptionExpireDate,
    bool? termsConsentStatus,
    bool? privacyConsentStatus,
  }) {
    return HeethingsAccount(
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      subscriptionResult: subscriptionResult ?? this.subscriptionResult,
      subscriptionExpireDate:
          subscriptionExpireDate ?? this.subscriptionExpireDate,
      termsConsentStatus: termsConsentStatus ?? this.termsConsentStatus,
      privacyConsentStatus: privacyConsentStatus ?? this.privacyConsentStatus,
    );
  }
}

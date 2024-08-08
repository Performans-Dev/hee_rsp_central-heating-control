import 'dart:convert';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:get/get.dart';

class SubscriptionResult {
  String subscriptionId;
  String expiresOn;
  SubscriptionType type;
  SubscriptionResult({
    required this.subscriptionId,
    required this.expiresOn,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'subscriptionId': subscriptionId,
      'expiresOn': expiresOn,
      'type': type.name,
    };
  }

  factory SubscriptionResult.fromMap(Map<String, dynamic> map) {
    return SubscriptionResult(
      subscriptionId: map['subscriptionId'] ?? '',
      expiresOn: map['expiresOn'] ?? '',
      type: SubscriptionType.values.firstWhereOrNull((e) => e == map['type']) ??
          SubscriptionType.none,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionResult.fromJson(String source) =>
      SubscriptionResult.fromMap(json.decode(source));
}

import 'package:central_heating_control/app/core/constants/api.dart';
import 'package:central_heating_control/app/data/models/account.dart';
import 'package:central_heating_control/app/data/models/activation_request.dart';
import 'package:central_heating_control/app/data/models/activation_result.dart';
import 'package:central_heating_control/app/data/models/app_settings.dart';
import 'package:central_heating_control/app/data/models/chc_device.dart';
import 'package:central_heating_control/app/data/models/forgot_password_request.dart';
import 'package:central_heating_control/app/data/models/generic_response.dart';
import 'package:central_heating_control/app/data/models/language_definition.dart';
import 'package:central_heating_control/app/data/models/register_request.dart';
import 'package:central_heating_control/app/data/models/signin_request.dart';
import 'package:central_heating_control/app/data/models/subscription_result.dart';
import 'package:central_heating_control/app/data/models/temperature_value.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/providers/base.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';

import 'package:dio/dio.dart';

class AppProvider {
  static Future<GenericResponse<AppSettings?>> fetchAppSettings() async {
    final response = await BaseNetworkProvider.get(Api.appSettings);
    if (response.success) {
      final a = AppSettings.fromMap(response.data);
      return GenericResponse.success(a);
    }

    return GenericResponse.error();
  }

  fetchHardwareSettings() {}

  static Future<GenericResponse<ChcDevice?>> registerChcDevice(
      {required ChcDevice request}) async {
    final response = await BaseNetworkProvider.post(
      Api.deviceRegister,
      data: request.toMap(),
    );
    if (response.success) {
      final d = ChcDevice.fromMap(response.data);
      return GenericResponse.success(d);
    }
    return GenericResponse.error();
  }

  static Future<GenericResponse<SubscriptionResult>> requestSubscription({
    required String activationId,
  }) async {
    /*  final response = await BaseNetworkProvider.post(
      Api.requestSubscription,
      data: {
        'activationId': activationId,
      },
    );
    if (response.success) {
      return GenericResponse.success(
        // SubscriptionResult(
        //   expiresOn: response.data['expiresOn'],
        //   subscriptionId: Guid.newGuid.toString(),
        //   type: SubscriptionType.values
        //           .firstWhereOrNull((e) => e.name == response.data['type']) ??
        //       SubscriptionType.none,
        // ),
        SubscriptionResult(
          expiresOn:
              DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          subscriptionId: Guid.newGuid.toString(),
          type: SubscriptionType.pro,
        ),
      );
    } */
    return GenericResponse.success(null);
  }

  static Future<GenericResponse<ActivationResult?>> checkActivation(
      {required ActivationRequest request}) async {
    final response = await BaseNetworkProvider.post(
      Api.checkActivation,
      data: request.toMap(),
    );
    if (response.success) {
      final ar = ActivationResult.fromMap(response.data);
      return GenericResponse.success(ar);
    }
    return GenericResponse.error();
  }

  static Future<GenericResponse<ActivationResult?>> activateDevice(
      {required ActivationRequest request}) async {
    final response = await BaseNetworkProvider.post(
      Api.activateDevice,
      data: request.toMap(),
    );
    if (response.success) {
      final ar = ActivationResult.fromMap(response.data);
      return GenericResponse.success(ar);
    }
    return GenericResponse.error();
  }

  static Future<GenericResponse<Account?>> accountSignin(
      {required SigninRequest request}) async {
/*     final account = Account(
      status: 1, displayName: "a", createdAt: "", token: "",
      id: "1", // Sabit id değeri

      email: 'ilkerr@okutman.com', 
  
    );

    return GenericResponse.success(account); */
    final response = await BaseNetworkProvider.post(
      Api.signin,
      data: request.toMap(),
    );
    if (response.success) {
      final account = Account.fromMap(response.data);
      return GenericResponse.success(account);
    }
    return GenericResponse.error();
  }

  static Future<GenericResponse> accountForgotPassword(
      {required ForgotPasswordRequest request}) async {
    await Future.delayed(const Duration(seconds: 1));
    return GenericResponse(
      message: 'Check your email to continue your password reset request.',
    );
  }

  static Future<GenericResponse> accountRegister(
      {required RegisterRequest request}) async {
    await Future.delayed(const Duration(seconds: 1));
    return GenericResponse.error(message: 'Not implemented yet');
  }

  userValidateAccount() {}

  fetchMqttInfo() {}

  addLog() {}

  static Future<GenericResponse<List<TimezoneDefinition>>>
      fetchTimezoneList() async {
    final timezones = <TimezoneDefinition>[];
    final response = await BaseNetworkProvider.get(Api.settingsTimezones);
    final json = response.data ?? StaticProvider.getTimezoneList;
    for (final map in json) {
      timezones.add(TimezoneDefinition.fromMap(map));
    }
    return GenericResponse.success(timezones);
  }

  static Future<GenericResponse<List<LanguageDefinition>>>
      fetchLanguageList() async {
    final langs = <LanguageDefinition>[];
    const fallBackLangs = StaticProvider.getLanguageList;
    final response = await BaseNetworkProvider.get(Api.settingsLanguages);
    final json = response.data ?? fallBackLangs;
    for (final map in json) {
      langs.add(LanguageDefinition.fromMap(map));
    }
    return GenericResponse.success(langs);
  }

  //fetchDateLocaleList() {}

  static Future<GenericResponse> downloadTemperatureValues() async {
    const url = "https://static.api2.run/temperature_values.json";
    List<TemperatureValue> list = [];
    final response = await Dio().get(url);
    if (response.statusCode == 200) {
      final json = response.data;
      for (var item in json) {
        list.add(TemperatureValue.fromMap(item));
      }
      await DbProvider.db.deleteTemperatureValues();

      await DbProvider.db.insertTemperatureValues(list);

      return GenericResponse.success(null);
    }
    return GenericResponse.error();
  }

  static Future<bool> testInternetConnection() async {
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 2);
    try {
      final response = await dio.get('https://heethings.io');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception catch (_) {
      return false;
    }
  }
}

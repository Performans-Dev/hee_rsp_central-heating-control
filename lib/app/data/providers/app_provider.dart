import 'package:central_heating_control/app/core/constants/api.dart';
import 'package:central_heating_control/app/data/models/generic_response.dart';
import 'package:central_heating_control/app/data/models/language_definition.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/providers/base.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';

class AppProvider {
  fetchAppSettings() {}

  fetchHardwareSettings() {}

  Future registerChcDevice() async {}

  Future checkActivation() async {}

  Future activateHardware() async {}

  checkHardware() {}

  Future userSignin() async {}

  userForgetPassword() {}

  userCreateAccount() {}

  userValidateAccount() {}

  fetchMqttInfo() {}

  addLog() {}

  static Future<GenericResponse<List<TimezoneDefinition>>>
      fetchTimezoneList() async {
    final timezones = <TimezoneDefinition>[];
    final response = await BaseNetworkProvider.get(Api.settingsTimezones);
    final json = response.data ?? StaticProvider.timezones;
    for (final map in json) {
      timezones.add(TimezoneDefinition.fromMap(map));
    }
    return GenericResponse.success(timezones);
  }

  static Future<GenericResponse<List<LanguageDefinition>>>
      fetchLanguageList() async {
    final langs = <LanguageDefinition>[];
    const fallBackLangs = StaticProvider.languages;
    final response = await BaseNetworkProvider.get(Api.settingsLanguages);
    final json = response.data ?? fallBackLangs;
    for (final map in json) {
      langs.add(LanguageDefinition.fromMap(map));
    }
    return GenericResponse.success(langs);
  }

  //fetchDateLocaleList() {}

  checkUpdates() {}
}

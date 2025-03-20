import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/preferences/preferences.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('AppController onInit');

    loadPreferencesFromBox();
  }

  @override
  void onReady() {
    print('AppController onReady');
    super.onReady();
  }

  //#region MARK: Preferences
  final _preferences = Preferences.empty().obs;
  Preferences get preferences => _preferences.value;
  void setPreferences(Preferences p) {
    _preferences.value = p;
    update();
    savePreferencesToBox();
  }
  //#endregion

  //#region MARK: Box
  Future<void> savePreferencesToBox() async {
    await Box.setString(
      key: Keys.preferences,
      value: _preferences.value.toJson(),
    );
  }

  void loadPreferencesFromBox() {
    final json = Box.getString(key: Keys.preferences);
    if (json.isNotEmpty) {
      _preferences.value = Preferences.fromJson(json);
      update();
    }
  }
  //#endregion
}

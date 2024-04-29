import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  //#region SESSION
  final RxString _sessionKey = ''.obs;
  String get sessionKey => _sessionKey.value;

  void startSession() {
    _sessionKey.value = Guid.newGuid.toString();
    update();
  }
  //#endregion
}

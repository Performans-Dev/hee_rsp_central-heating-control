import 'package:central_heating_control/app/data/services/app.dart';
import 'package:get/get.dart';

class FileServices {
  static Future<bool> createMissingFolders() async {
    // mock
    await Future.delayed(const Duration(milliseconds: 500));
    //TODO: replace with real code

    final AppController appController = Get.find();
    appController.setDidCheckFoldersExists(true);

    return true;
  }
}

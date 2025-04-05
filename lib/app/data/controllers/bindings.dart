import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/controllers/app_user.dart';
import 'package:central_heating_control/app/data/controllers/input_output.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => AppController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => AppUserController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => IOController(),
      permanent: true,
    );
  }
}

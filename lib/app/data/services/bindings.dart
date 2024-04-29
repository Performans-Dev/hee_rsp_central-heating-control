import 'package:central_heating_control/app/data/services/app.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => AppController(),
      permanent: true,
    );
  }
}

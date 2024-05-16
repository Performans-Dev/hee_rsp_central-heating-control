import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/pin.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => AppController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => DataController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => PinController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => ProcessController(),
      permanent: true,
    );
  }
}

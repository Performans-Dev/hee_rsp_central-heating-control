import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/process.dart';
import 'package:central_heating_control/app/data/services/screen_saver.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync(
      () async => AppController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => ScreenSaverController(),
      permanent: true,
    );
    await Get.putAsync(
      () async => SetupController(),
      permanent: true,
    );

    /// Handles DB related data
    await Get.putAsync(
      () async => DataController(),
      permanent: true,
    );

    /// GPIO and Serial Pins and its states
    await Get.putAsync(
      () async => ChannelController(),
      permanent: true,
    );

    ///
    await Get.putAsync(
      () async => ProcessController(),
      permanent: true,
    );
  }
}

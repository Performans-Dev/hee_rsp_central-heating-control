import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:get/get.dart';

class Buzz {
  static void mini() {
    final GpioController gpio = Get.find();
    gpio.buzz(BuzzerType.mini);
  }

  static void feedback() {
    final GpioController gpio = Get.find();
    gpio.buzz(BuzzerType.feedback);
  }

  static void success() {
    final GpioController gpio = Get.find();
    gpio.buzz(BuzzerType.success);
  }

  static void lock() {
    final GpioController gpio = Get.find();
    gpio.buzz(BuzzerType.lock);
  }

  static void error() {
    final GpioController gpio = Get.find();
    gpio.buzz(BuzzerType.error);
  }

  static void alarm() {
    final GpioController gpio = Get.find();
    gpio.buzz(BuzzerType.alarm);
  }
}

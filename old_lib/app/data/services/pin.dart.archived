import 'package:get/get.dart';

class PinController extends GetxController {
  //

  final RxList<String> _digits = <String>[
    '',
    '',
    '',
    '',
    '',
    '',
  ].obs;

  List<String> get digits => _digits;

  String get pin {
    String result = '';
    for (final item in digits) {
      result += item;
    }
    return result;
  }

  void resetPin() {
    _digits.assignAll([
      '',
      '',
      '',
      '',
      '',
      '',
    ]);
    update();
  }

  void onDigitTapped(String digit) {
    if (digit == '>') {
      Future.delayed(const Duration(milliseconds: 150), () {
        Get.back(result: pin, closeOverlays: true);
      });
    } else if (digit == 'x') {
      deleteLast();
    } else {
      final newDigits = <String>[
        '',
        '',
        '',
        '',
        '',
        '',
      ];
      for (int i = 0; i < 6; i++) {
        if (digits[i].isNotEmpty) {
          newDigits[i] = digits[i];
        } else {
          newDigits[i] = digit;
          break;
        }
      }
      _digits.assignAll(newDigits);
      update();
      if (newDigits.last != '') {
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.back(result: pin, closeOverlays: true);
        });
      }
    }
  }

  void deleteLast() {
    for (int i = 5; i >= 0; i--) {
      if (digits[i].isNotEmpty) {
        _digits[i] = '';
        break;
      }
    }
    update();
  }
}

import 'package:central_heating_control/app/data/providers/db.dart';
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
      Get.back(result: pin);
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
        Get.back(result: pin);
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

  Future<int> savePin(String newPin, String username) async {
    final result = await DbProvider.db.savePin(newPin, username);
    return result;
  }
}

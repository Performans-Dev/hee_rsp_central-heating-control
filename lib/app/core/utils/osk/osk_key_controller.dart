import 'package:central_heating_control/app/core/utils/osk/data.dart';
import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/core/utils/osk/model.dart';
import 'package:get/get.dart';

class OskKeyController extends GetxController {
  final OnScreenKeyboardInputType inputType;
  final _layoutType = OskType.lowerCase.obs;
  final _currentText = ''.obs;

  OskKeyController({required this.inputType});

  String get currentText => _currentText.value;
  OskType get layoutType => _layoutType.value;

  List<OskKeyModel> get filteredKeys {
    return OskData.keys.where((key) {
      return key.layoutType == layoutType || key.layoutType == OskType.all;
    }).toList();
  }

  List<OskKeyModel> getKeys({
    required OskType layouttype,
    required int row,
    required int column,
  }) {
    return OskData.keys
        .where((element) =>
            (element.layoutType == layouttype ||
                element.layoutType == OskType.all) &&
            element.row == row &&
            element.column == column)
        .toList();
  }

  void receiveOnTap(KeyType type, String value) {
    switch (type) {
      case KeyType.character:
        _currentText.value += value;
        break;
      case KeyType.space:
        _currentText.value += " ";
        break;
      case KeyType.enter:
        Get.back(result: currentText);
        break;
      case KeyType.hideKeyboard:
        Get.back(result: currentText);

        break;
      case KeyType.backspace:
        if (currentText.isNotEmpty) {
          _currentText.value = currentText.substring(0, currentText.length - 1);
        }
        break;
      case KeyType.shift:
        switch (_layoutType.value) {
          case OskType.lowerCase:
            _layoutType.value = OskType.upperCase;
            break;
          case OskType.upperCase:
            _layoutType.value = OskType.lowerCase;
            break;
          case OskType.numbers:
            _layoutType.value = OskType.specialCharacters;
            break;
          case OskType.specialCharacters:
            _layoutType.value = OskType.numbers;
            break;
          default:
            break;
        }
        break;
      case KeyType.alt:
        switch (_layoutType.value) {
          case OskType.lowerCase:
          case OskType.upperCase:
            _layoutType.value = OskType.numbers;
            break;
          case OskType.numbers:
          case OskType.specialCharacters:
            _layoutType.value = OskType.lowerCase;
            break;
          default:
            break;
        }

        break;
      default:
        break;
    }

    update();
  }
}

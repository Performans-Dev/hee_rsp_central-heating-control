import 'package:central_heating_control/app/core/utils/osk/data.dart';
import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/core/utils/osk/model.dart';
import 'package:get/get.dart';

class OskKeyController extends GetxController {
  final OnScreenKeyboardInputType inputType;
  final String initialValue;
  final String label;
  final bool numberOnly;
  final _layoutType = OskType.lowerCase.obs;
  final _currentText = ''.obs;
  final _isShiftActive = false.obs;

  OskKeyController({
    required this.inputType,
    required this.initialValue,
    required this.label,
    required this.numberOnly,
  }) {
    _currentText.value = initialValue;
    updateLayoutBasedOnInputType();
  }

  String get currentText => _currentText.value;
  OskType get layoutType => _layoutType.value;
  bool get isShiftActive => _isShiftActive.value;

  List<OskKeyModel> get filteredKeys {
    return OskData.keys.where((key) {
      if (numberOnly &&
          (key.keyType == KeyType.alt || key.keyType == KeyType.shift)) {
        return false;
      }
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
        if (inputType == OnScreenKeyboardInputType.name &&
            _currentText.isEmpty) {
          _currentText.value += value.toUpperCase();
          _layoutType.value = OskType.upperCase;
        } else if (inputType == OnScreenKeyboardInputType.name &&
            _currentText.endsWith(' ')) {
          _currentText.value += value.toUpperCase();
          _layoutType.value = OskType.upperCase;
        } else {
          _currentText.value += value.toLowerCase();
          _layoutType.value = OskType.lowerCase;
        }
        update();

        break;
      case KeyType.space:
        _currentText.value += " ";
        break;
      case KeyType.enter:
        Get.back(result: currentText);
        break;
      case KeyType.hideKeyboard:
        Get.back(result: "");
        break;
      case KeyType.backspace:
        if (currentText.isNotEmpty) {
          _currentText.value = currentText.substring(0, currentText.length - 1);
        }
        break;
      case KeyType.shift:
        if (!numberOnly) {
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
        }
        break;
      case KeyType.alt:
        if (!numberOnly) {
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
        }
        break;
      default:
        break;
    }
    update();
  }

  void updateLayoutBasedOnInputType() {
    switch (inputType) {
      case OnScreenKeyboardInputType.name:
        _layoutType.value = OskType.upperCase;
        break;
      case OnScreenKeyboardInputType.email:
        _layoutType.value = OskType.lowerCase;
        break;
      case OnScreenKeyboardInputType.number:
        _layoutType.value = OskType.numbers;
        break;
      case OnScreenKeyboardInputType.text:
        _layoutType.value = OskType.lowerCase;
        break;
      case OnScreenKeyboardInputType.alphanumeric:
        _layoutType.value = OskType.specialCharacters;
        break;
      default:
        _layoutType.value = OskType.lowerCase;
        break;
    }
  }
}

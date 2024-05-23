import 'package:central_heating_control/app/core/utils/osk/osk_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnScreenKeyboard extends StatefulWidget {
  const OnScreenKeyboard({super.key});

  @override
  State<OnScreenKeyboard> createState() => _OnScreenKeyboardState();
}

class _OnScreenKeyboardState extends State<OnScreenKeyboard> {
  String text = "";
  bool isShiftEnabled = false;
  bool isNumericMode = false;
  bool isSpecialSymbols = false;

  final List<List<String>> lowercaseKeys = [
    ["q", "w", "e", "r", "t", "y", "u", "ı", "o", "p", "ğ", "ü"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ş", "i"],
    ["z", "x", "c", "v", "b", "n", "m", "ö", "ç"]
  ];

  final List<List<String>> numericKeys = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "?"],
    ["@", "#", "\$", "%", "*", "(", ")", "'", "\"", "≠", "‴"],
    ["%", "_", "+", "=", "/", ";", ":", ",", "."]
  ];

  final List<List<String>> numericKeys2 = [
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "?"],
    ["€", "£", "¥", "_", "[", "]", "{", "}", "ˎ", "≤", "≥"],
    [".", "|", "∼", "∖", "<", ">", "!", "?"]
  ];

  void _toggleNumericMode() {
    setState(() {
      isNumericMode = !isNumericMode;
      isSpecialSymbols = false;
    });
  }

  void _toggleSpecialSymbols() {
    setState(() {
      isSpecialSymbols = !isSpecialSymbols;
      isNumericMode = false;
    });
  }

  String _getCharacter(String value) {
    return isShiftEnabled && value != "Shift" ? value.toUpperCase() : value;
  }

  void _onKeyPress(String value) {
    if (value == "⇑") {
      isShiftEnabled = !isShiftEnabled;
    } else if (value == "⌫") {
      if (text.isNotEmpty) {
        text = text.substring(0, text.length - 1);
      }
    } else if (value == "#+=") {
      isNumericMode = false;
      isSpecialSymbols = true;
    } else if (value == ".?123") {
      isNumericMode = true;
      isSpecialSymbols = false;
    } else {
      text += _getCharacter(value);
    }
    setState(() {});
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return OSKKeyWidget(
          child: Center(
              child: Text(
            _getCharacter(key),
            style: const TextStyle(fontSize: 25, color: Colors.black),
          )),
          onTap: () => _onKeyPress(key),
        );
      }).toList(),
    );
  }

  Widget _buildThirdRowWithBackspace(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        return OSKKeyWidget(
          child: Center(
              child: Text(
            _getCharacter(key),
            style: const TextStyle(fontSize: 25, color: Colors.black),
          )),
          onTap: () => _onKeyPress(key),
        );
      }).followedBy([
        OSKKeyWidget(
          width: 190,
          isOther: true,
          child: const Icon(Icons.backspace_outlined),
          onTap: () => _onKeyPress("⌫"),
        )
      ]).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> keys = isSpecialSymbols
        ? numericKeys2
        : (isNumericMode ? numericKeys : lowercaseKeys);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Container(
            color: Colors.grey.withOpacity(0.1),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                color: Colors.grey.withOpacity(0.3),
                child: Column(
                  children: [
                    for (final row in keys.take(2)) _buildKeyboardRow(row),
                    _buildThirdRowWithBackspace(keys[2]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OSKKeyWidget(
                          width: 100,
                          onTap: () {
                            if (isSpecialSymbols) {
                              _toggleSpecialSymbols();
                            } else if (isNumericMode) {
                              _toggleNumericMode();
                            } else {
                              _onKeyPress("⇑");
                            }
                          },
                          isOther: true,
                          child: isNumericMode
                              ? const Center(child: Text("#+="))
                              : isSpecialSymbols
                                  ? const Text(".?123")
                                  : const Icon(Icons.arrow_upward_sharp),
                        ),
                        OSKKeyWidget(
                          width: 100,
                          onTap: () => _toggleNumericMode(),
                          isOther: true,
                          child: Center(
                            child: Text(
                              isNumericMode
                                  ? "abc"
                                  : !isSpecialSymbols
                                      ? ".?123"
                                      : "#+=",
                            ),
                          ),
                        ),
                        OSKKeyWidget(
                          width: 380,
                          child: const Icon(Icons.space_bar),
                          onTap: () => _onKeyPress(" "),
                        ),
                        OSKKeyWidget(
                          width: 110,
                          onTap: () => Get.back(result: text),
                          isOther: true,
                          child: const Icon(Icons.subdirectory_arrow_left),
                        ),
                        OSKKeyWidget(
                          width: 70,
                          onTap: () => Get.back(result: text),
                          isOther: true,
                          child: const Icon(Icons.arrow_drop_down_outlined),
                        ),
                      ],
                    ),
                  ],
                ))
          ])
        ]));
  }
}

import 'package:central_heating_control/app/core/utils/osk/osk_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class OnScreenKeyboard extends StatefulWidget {
  OnScreenKeyboard({Key? key}) : super(key: key);

  @override
  State<OnScreenKeyboard> createState() => _OnScreenKeyboardState();
}

class _OnScreenKeyboardState extends State<OnScreenKeyboard> {
  String text = "";
  bool isShiftEnabled = false;
  bool isNumericMode = false;

  final List<List<String>> lowercaseKeys = [
    ["q", "w", "e", "r", "t", "y", "u", "ı", "o", "p", "ğ", "ü"],
    ["a", "s", "d", "f", "g", "h", "j", "k", "l", "ş", "i"],
    ["z", "x", "c", "v", "b", "n", "m", "ö", "ç", "<"],
  ];

  final List<List<String>> numericKeys = [
    ["#", "\$", "_", "-", "1", "2", "3", "?"],
    ["@", "(", ")", "=", "+", "4", "5", "6", "!"],
    ["{&=", "'", ":", "%", "/", "7", "8", "9", "<"],
    ["*", ",", "0", "."],
  ];

  void _toggleNumericMode() {
    isNumericMode = !isNumericMode;
    setState(() {});
  }

  String _getCharacter(String value) {
    return isShiftEnabled && value != "Shift" ? value.toUpperCase() : value;
  }

  void _onKeyPress(String value) {
    if (value == "Shift") {
      isShiftEnabled = !isShiftEnabled;
    } else if (value == "<") {
      if (text.isNotEmpty) {
        text = text.substring(0, text.length - 1);
      }
    } else {
      text += _getCharacter(value);
    }
    setState(() {});
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return OSKKeyWidget(
          label: _getCharacter(key),
          onTap: () => _onKeyPress(key),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> keys = isNumericMode ? numericKeys : lowercaseKeys;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Container(
            color: Colors.white.withOpacity(0.3),
            child: Image.asset(
              'assets/images/kb.png',
              fit: BoxFit.contain,
            ),
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
                    for (final row in keys) _buildKeyboardRow(row),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OSKKeyWidget(
                          label: isNumericMode ? "abc" : "123",
                          onTap: () => _toggleNumericMode(),
                          isOther: true,
                        ),
                        OSKKeyWidget(
                          label: "Shift",
                          onTap: () => _onKeyPress("Shift"),
                          isOther: true,
                        ),
                        SizedBox(
                          width: 400,
                          child: OSKKeyWidget(
                            label: "Space",
                            onTap: () => _onKeyPress(" "),
                          ),
                        ),
                        OSKKeyWidget(
                          label: isNumericMode ? "abc" : "123",
                          onTap: () => _toggleNumericMode(),
                          isOther: true,
                        ),
                        OSKKeyWidget(
                          label: "Enter",
                          onTap: () => Get.back(result: text),
                          isOther: true,
                        ),
                        OSKKeyWidget(
                          label: "Back",
                          onTap: () => Get.back(result: text),
                          isOther: true,
                        ),
                      ],
                    ),
                  ],
                ))
          ])
        ]));
  }
}

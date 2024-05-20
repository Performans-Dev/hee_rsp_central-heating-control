import 'package:central_heating_control/app/core/utils/osk/osk_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnScreenKeyboard extends StatefulWidget {
  OnScreenKeyboard({Key? key}) : super(key: key);

  @override
  State<OnScreenKeyboard> createState() => _OnScreenKeyboardState();
}

class _OnScreenKeyboardState extends State<OnScreenKeyboard> {
  late String text;

  @override
  void initState() {
    super.initState();
    text = Get.parameters["value"] ?? "";
  }

  void _onKeyPress(String value) {
    if (value == "<") {
      if (text.isNotEmpty) {
        text = text.substring(0, text.length - 1);
      }
    } else {
      text += value;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.grey[400],
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OSKKeyWidget(label: "Q", onTap: () => _onKeyPress("Q")),
                    OSKKeyWidget(label: "W", onTap: () => _onKeyPress("W")),
                    OSKKeyWidget(label: "E", onTap: () => _onKeyPress("E")),
                    OSKKeyWidget(label: "R", onTap: () => _onKeyPress("R")),
                    OSKKeyWidget(label: "T", onTap: () => _onKeyPress("T")),
                    OSKKeyWidget(label: "Y", onTap: () => _onKeyPress("Y")),
                    OSKKeyWidget(label: "U", onTap: () => _onKeyPress("U")),
                    OSKKeyWidget(label: "I", onTap: () => _onKeyPress("I")),
                    OSKKeyWidget(label: "O", onTap: () => _onKeyPress("O")),
                    OSKKeyWidget(label: "P", onTap: () => _onKeyPress("P")),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OSKKeyWidget(label: "A", onTap: () => _onKeyPress("A")),
                    OSKKeyWidget(label: "S", onTap: () => _onKeyPress("S")),
                    OSKKeyWidget(label: "D", onTap: () => _onKeyPress("D")),
                    OSKKeyWidget(label: "F", onTap: () => _onKeyPress("F")),
                    OSKKeyWidget(label: "G", onTap: () => _onKeyPress("G")),
                    OSKKeyWidget(label: "H", onTap: () => _onKeyPress("H")),
                    OSKKeyWidget(label: "J", onTap: () => _onKeyPress("J")),
                    OSKKeyWidget(label: "K", onTap: () => _onKeyPress("K")),
                    OSKKeyWidget(label: "L", onTap: () => _onKeyPress("L")),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OSKKeyWidget(label: "Z", onTap: () => _onKeyPress("Z")),
                    OSKKeyWidget(label: "X", onTap: () => _onKeyPress("X")),
                    OSKKeyWidget(label: "C", onTap: () => _onKeyPress("C")),
                    OSKKeyWidget(label: "V", onTap: () => _onKeyPress("V")),
                    OSKKeyWidget(label: "B", onTap: () => _onKeyPress("B")),
                    OSKKeyWidget(label: "N", onTap: () => _onKeyPress("N")),
                    OSKKeyWidget(label: "M", onTap: () => _onKeyPress("M")),
                    OSKKeyWidget(label: "<", onTap: () => _onKeyPress("<")),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OSKKeyWidget(
                      label: "🔽",
                      onTap: () => Get.back(result: 'icindeki yazi budur'),
                    ),
                    Container(
                        width: 200,
                        child: OSKKeyWidget(
                            label: "Space", onTap: () => _onKeyPress(" "))),
                    OSKKeyWidget(
                        label: "Enter", onTap: () => Get.back(result: text)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

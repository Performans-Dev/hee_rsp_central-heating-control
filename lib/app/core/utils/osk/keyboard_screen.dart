import 'package:central_heating_control/app/core/utils/osk/osk_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnScreenKeyboard extends StatefulWidget {
  OnScreenKeyboard({super.key});

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
      body: Stack(
        children: [
          Image.asset(
            'assets/images/kb.png',
            fit: BoxFit.contain,
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 800,
                height: 200,
                color: Colors.orange,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.only(bottom: 100.0),
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              )),
          Align(
            alignment: Alignment.centerLeft,
            child: OSKKeyWidget(
              label: "q",
              onTap: () => _onKeyPress("q"),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: OSKKeyWidget(
                label: "<",
                onTap: () => _onKeyPress("<"),
              )),
          Align(
              alignment: Alignment.topRight,
              child: OSKKeyWidget(
                label: "Enter",
                onTap: () => Get.back(result: text),
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 107,
              child: OSKKeyWidget(
                label: "🔽",
                onTap: () => Get.back(result: 'icindeki yazi budur'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 400,
              child: OSKKeyWidget(
                label: "",
                onTap: () => _onKeyPress(" "),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:central_heating_control/app/core/utils/osk/osk_key_controller.dart';
import 'package:central_heating_control/app/core/utils/osk/data.dart';
import 'package:central_heating_control/app/core/utils/osk/enum.dart';

import 'package:central_heating_control/app/core/utils/osk/osk_key_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// inputtype
/// initialvalue
/// label,
/// numberOnly (bool)
/// alt shift tuşları numberonly true ise çalışmamalı.
class OnScreenKeyboard extends StatefulWidget {
  const OnScreenKeyboard({
    super.key,
  });

  @override
  State<OnScreenKeyboard> createState() => _OnScreenKeyboardState();
}

class _OnScreenKeyboardState extends State<OnScreenKeyboard> {
  late OnScreenKeyboardInputType inputType;
  late OskKeyController oskKeyController;
  String text = "";
  late String initialValue;
  late String label;
  late bool numberOnly;
  @override
  void initState() {
    super.initState();
    String inputTypeString = Get.parameters["inputType"] ?? "";
    inputType = OnScreenKeyboardInputType.values.firstWhere(
        (e) => e.toString() == 'OnScreenKeyboardInputType.$inputTypeString',
        orElse: () => OnScreenKeyboardInputType.text);
    label = Get.parameters["label"] ?? "";
    numberOnly = Get.parameters["numberOnly"] == "true";
    initialValue = Get.parameters["initialValue"] ?? "";
    oskKeyController = Get.put(OskKeyController(
        inputType: inputType,
        label: label,
        initialValue: initialValue,
        numberOnly: numberOnly));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OskKeyController>(
      builder: (oskKeyController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                color: Colors.blueGrey.withOpacity(0.2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        label,
                        style: const TextStyle(
                            fontSize: 22, color: Colors.black54),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          oskKeyController.currentText,
                          style: const TextStyle(
                              fontSize: 32, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  for (int row = 0; row < 4; row++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int column = 0; column <= 11; column++)
                          ...oskKeyController
                              .getKeys(
                            row: row,
                            column: column,
                            layouttype: oskKeyController.layoutType,
                          )
                              .map(
                            (key) {
                              return OskKeyWidget(
                                model: key,
                                onTap: () {
                                  oskKeyController.receiveOnTap(
                                      key.keyType, key.value ?? "");
                                },
                              );
                            },
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

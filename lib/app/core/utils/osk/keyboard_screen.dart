import 'package:central_heating_control/app/core/utils/osk/app.dart';
import 'package:central_heating_control/app/core/utils/osk/data.dart';
import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/core/utils/osk/model.dart';
import 'package:central_heating_control/app/core/utils/osk/osk_key.dart';
import 'package:central_heating_control/app/core/utils/osk/osk_key_v2.dart';
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
  @override
  void initState() {
    super.initState();
    inputType = OnScreenKeyboardInputType
        .values[int.parse(Get.parameters["inputType"] ?? "0")];
    oskKeyController = Get.put(OskKeyController(inputType: inputType));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OskKeyController>(builder: (oskKeyController) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(color: Colors.grey.withOpacity(0.1)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          oskKeyController.currentText,
                          style: const TextStyle(
                              fontSize: 24, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                for (int row = 0; row < 4; row++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int column = 0; column < 11; column++)
                        ...oskKeyController
                            .getKeys(
                          row: row,
                          column: column,
                          layouttype: oskKeyController.layoutType,
                        )
                            .map((key) {
                          return OskKeyWidgetV2(
                            model: key,
                            onTap: () {
                              oskKeyController.receiveOnTap(
                                  key.keyType, key.value ?? "");
                            },
                          );
                        }),
                    ],
                  ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

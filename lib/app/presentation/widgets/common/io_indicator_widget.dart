import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';

class IoIndicatorWidget extends StatelessWidget {
  const IoIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return IconButton(
        onPressed: () {
          //snackbar
          Get.snackbar(
            'IO Indicator',
            'TODO: navigate to schematics',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        icon: SizedBox(
          width: kToolbarHeight,
          height: 20,
          child: Column(
            spacing: 2,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final pin in app.digitalOutputs)
                        OutputIndicatorDotWidget(index: pin.pinIndex),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final pin in app.digitalInputs)
                        InputIndicatorDotWidget(index: pin.pinIndex),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}

class OutputIndicatorDotWidget extends StatelessWidget {
  const OutputIndicatorDotWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final isLit = Random().nextBool();
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isLit ? Colors.greenAccent : Colors.grey.shade300,
      ),
    );
  }
}

class InputIndicatorDotWidget extends StatelessWidget {
  const InputIndicatorDotWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final isLit = Random().nextBool();
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isLit ? Colors.orangeAccent : Colors.grey.shade300,
      ),
    );
  }
}

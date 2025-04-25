import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        icon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(
                4,
                (index) => ButtonIndicatorWidget(
                    value: app.hwButtons[index].value,
                    label: (index + 1).toString())),
            SizedBox(
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
                            OutputIndicatorDotWidget(value: pin.value),
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
                            InputIndicatorDotWidget(value: pin.value),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class OutputIndicatorDotWidget extends StatelessWidget {
  const OutputIndicatorDotWidget({super.key, required this.value});
  final bool value;

  @override
  Widget build(BuildContext context) {
    // final isLit = Random().nextBool();
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value ? Colors.greenAccent : Colors.grey.shade300,
      ),
    );
  }
}

class InputIndicatorDotWidget extends StatelessWidget {
  const InputIndicatorDotWidget({super.key, required this.value});
  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value ? Colors.orangeAccent : Colors.grey.shade300,
      ),
    );
  }
}

class ButtonIndicatorWidget extends StatelessWidget {
  const ButtonIndicatorWidget(
      {super.key, required this.value, required this.label});
  final bool value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: UiDimens.br12,
        color: value ? Colors.greenAccent : Colors.grey.shade300,
      ),
      child: Text(label),
    );
  }
}

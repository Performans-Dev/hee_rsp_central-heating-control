import 'package:flutter/material.dart';
import 'package:get/get.dart';

class IoIndicatorWidget extends StatelessWidget {
  const IoIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //snackbar
        Get.snackbar(
          'IO Indicator',
          'TODO: navigate to schematics',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: SizedBox(
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
                    for (int i = 1; i <= 8; i++)
                      OutputIndicatorDotWidget(index: i),
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
                    for (int i = 1; i <= 8; i++)
                      InputIndicatorDotWidget(index: i),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OutputIndicatorDotWidget extends StatelessWidget {
  const OutputIndicatorDotWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
    );
  }
}

class InputIndicatorDotWidget extends StatelessWidget {
  const InputIndicatorDotWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
    );
  }
}

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HwButton extends StatelessWidget {
  const HwButton({
    super.key,
    required this.location,
    this.child,
    this.callback,
    this.enabled = true,
    this.visible = false,
    this.isPrimary = false,
  });
  final HardwareButtonLocation location;
  final Widget? child;
  final GestureTapCallback? callback;
  final bool visible;
  final bool enabled;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    double screenHeight = Get.height;
    double availableHeight = screenHeight - (2 * kToolbarHeight);
    double itemHeight = availableHeight / 4;

    double? left;
    double? right;
    double top = (location.index % 4) * itemHeight;
    BorderRadius? radius;

    switch (location) {
      case HardwareButtonLocation.l0:
      case HardwareButtonLocation.l1:
      case HardwareButtonLocation.l2:
      case HardwareButtonLocation.l3:
        left = 0;
        right = null;
        radius = BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        );
        break;
      case HardwareButtonLocation.r0:
      case HardwareButtonLocation.r1:
      case HardwareButtonLocation.r2:
      case HardwareButtonLocation.r3:
        left = null;
        right = 0;
        radius = BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        );
        break;
    }

    List<Color> colors = [
      Theme.of(context).focusColor,
      Theme.of(context).focusColor.withOpacity(0.1),
    ];
    if (isPrimary) {
      colors = [
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor.withOpacity(0.7),
      ];
    }

    return !visible
        ? Container()
        : Positioned(
            left: left,
            right: right,
            top: kToolbarHeight + top,
            child: Center(
              child: InkWell(
                borderRadius: radius,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  height: 60,
                  // width: 200,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: child,
                  ),
                ),
              ),
            ),
          );
  }
}

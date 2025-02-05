import 'dart:async';

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/cc.dart';
import 'package:flutter/material.dart';

class FlameIndicatorWidget extends StatefulWidget {
  const FlameIndicatorWidget({super.key, required this.value});
  final ControlMode value;

  @override
  State<FlameIndicatorWidget> createState() => _FlameIndicatorWidgetState();
}

class _FlameIndicatorWidgetState extends State<FlameIndicatorWidget> {
  late Timer timer;
  bool b = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (t) => setState(() => b = !b),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: AnimatedOpacity(
        opacity: widget.value == ControlMode.off
            ? 0.3
            : b
                ? 1
                : 0.4,
        duration: const Duration(milliseconds: 200),
        child: Icon(
          Icons.sunny,
          size: 20,
          color: CCUtils.stateColor(widget.value),
        ),
      ),
    );
  }
}

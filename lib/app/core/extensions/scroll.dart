import 'dart:ui';

import 'package:flutter/material.dart';

class TouchScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.mouse,
      };
}

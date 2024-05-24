import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/core/utils/osk/model.dart';
import 'package:flutter/material.dart';

class OskKeyWidgetV2 extends StatelessWidget {
  final OskKeyModel model;
  final GestureTapCallback? onTap;
  const OskKeyWidgetV2({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(); // Default empty container
    if (model.display is String) {
      child = Text(model.display as String);
    } else if (model.display is IconData) {
      child = Icon(model.display as IconData);
    }
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 3.2, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: Container(
          child: Center(child: child),
        ),
      ),
    );
  }
}

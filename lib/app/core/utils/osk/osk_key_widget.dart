import 'package:central_heating_control/app/core/utils/osk/enum.dart';
import 'package:central_heating_control/app/core/utils/osk/model.dart';
import 'package:flutter/material.dart';

class OskKeyWidget extends StatelessWidget {
  final OskKeyModel model;
  final GestureTapCallback? onTap;

  const OskKeyWidget({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    if (model.display is String) {
      child = Text(
        model.display as String,
        style: const TextStyle(fontSize: 25),
      );
    } else if (model.display is IconData) {
      child = Icon(
        model.display as IconData,
        size: 30,
      );
    }

    double width;
    double height;
    Color color;

    switch (model.keyType) {
      case KeyType.enter:
      case KeyType.hideKeyboard:
        width = 90;
        height = 57;
        color = Colors.blueGrey.withOpacity(0.4);

      case KeyType.shift:
      case KeyType.alt:
        width = 90;
        height = 57;
        color = Colors.blueGrey.withOpacity(0.4);

        break;
      case KeyType.backspace:
        width = 185;
        height = 57;
        color = Colors.blueGrey.withOpacity(0.4);
        break;
      case KeyType.space:
        width = 410;
        height = 57;
        color = Colors.white.withOpacity(0.7);
        break;
      case KeyType.character:
        width = 60.5;
        height = 57;
        color = Colors.white.withOpacity(0.7);
        break;
      default:
        width = 60;
        height = 57;
        color = Colors.white;
        break;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          width: width,
          height: height,
          child: Center(child: child),
        ),
      ),
    );
  }
}

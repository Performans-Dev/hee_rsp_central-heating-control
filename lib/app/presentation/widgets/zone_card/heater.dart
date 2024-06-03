import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:flutter/material.dart';

class ZoneCardHeaterDisplayWidget extends StatelessWidget {
  const ZoneCardHeaterDisplayWidget({super.key, required this.heaters});
  final List<HeaterDevice> heaters;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: heaters
            .map((e) => Icon(
                  Icons.sunny,
                  color: e.state == 0
                      ? Colors.grey.withOpacity(0.3)
                      : e.state == 1
                          ? Colors.yellow
                          : e.state == 2
                              ? Colors.orange
                              : Colors.red,
                ))
            .toList(),
      ),
    );
  }
}

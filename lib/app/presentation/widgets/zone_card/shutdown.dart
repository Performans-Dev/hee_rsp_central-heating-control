import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:flutter/material.dart';

class ZoneCardHeaterShutdownWidget extends StatelessWidget {
  const ZoneCardHeaterShutdownWidget({super.key, required this.heaters});
  final List<HeaterDevice> heaters;
  @override
  Widget build(BuildContext context) {
    bool anyHeaterOn = false;
    for (final h in heaters) {
      if (h.state != 0) {
        anyHeaterOn = true;
      }
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: anyHeaterOn
            ? () {
                print('shutdown');
              }
            : null,
      ),
    );
  }
}

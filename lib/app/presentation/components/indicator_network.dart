import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBarNetworkIndicator extends StatelessWidget {
  const AppBarNetworkIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      String message = '';
      if (app.networkName != null) {
        message += 'Wifi:\n${app.networkName}\n\n';
      }
      if (app.networkIp != null) {
        message += 'IP:\n${app.networkIp}\n\n';
      }
      if (app.networkGateway != null) {
        message += 'Gateway:\n${app.networkGateway}';
      }
      IconData iconData = Icons.signal_wifi_connected_no_internet_4;
      switch (app.networkIndicator) {
        case NetworkIndicator.none:
          iconData = Icons.signal_wifi_statusbar_connected_no_internet_4;
          break;
        case NetworkIndicator.ethernet:
          iconData = Icons.lan_outlined;
          break;
        case NetworkIndicator.wifi:
          iconData = Icons.wifi;
          break;
      }
      return app.didConnected
          ? Tooltip(
              message: message,
              
              child: Icon(iconData),
            )
          : Icon(Icons.wifi_off);
    });
  }
}

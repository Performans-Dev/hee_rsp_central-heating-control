import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevNetworkInfoWidget extends StatelessWidget {
  const DevNetworkInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Network Info'),
                  TextButton.icon(
                    onPressed: app.getNetworkInfo,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                ],
              ),
              const Divider(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('didConnectivityResultReceived'),
                    selected: app.didConnectivityResultReceived,
                  ),
                  ChoiceChip(
                    label: const Text('didConnectionChecked'),
                    selected: app.didConnectionChecked,
                  ),
                  ChoiceChip(
                    label: const Text('didConnected'),
                    selected: app.didConnected,
                  ),
                  Chip(
                    label:
                        Text('Network Indicator: ${app.networkIndicator.name}'),
                  ),
                  Chip(
                    label: Text('networkName: ${app.networkName}'),
                  ),
                  Chip(
                    label: Text('networkIp: ${app.networkIp}'),
                  ),
                  Chip(
                    label: Text('networkGateway: ${app.networkGateway}'),
                  ),
                  Chip(
                    label: Text('eth0Mac: ${app.eth0Mac}'),
                  ),
                  Chip(
                    label: Text('wlan0Mac: ${app.wlan0Mac}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

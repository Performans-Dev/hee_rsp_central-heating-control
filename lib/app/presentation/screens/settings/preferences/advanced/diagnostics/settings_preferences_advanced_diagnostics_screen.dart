import 'package:central_heating_control/app/data/services/state_controller.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesAdvancedDiagnosticsScreen extends StatelessWidget {
  const SettingsPreferencesAdvancedDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(
      builder: (sc) {
        return GetBuilder<StateController>(
          builder: (sc) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Diagnostics'),
              ),
              body: Row(
                children: [
                  Expanded(
                    child: PiScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...sc.outputChannels.map((e) => DevTile(channel: e)),
                        ],
                      ),
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    child: PiScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...sc.inputChannels.map((e) => DevTile(channel: e)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class DevTile extends StatelessWidget {
  const DevTile({super.key, required this.channel});
  final ChannelDefinition channel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(channel.name),
      subtitle: Text('Device: ${channel.deviceId} Index: ${channel.pinIndex}'),
      leading: Text('${channel.id}'),
      trailing: Text(channel.type.name),
    );
  }
}

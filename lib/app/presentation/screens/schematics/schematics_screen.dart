import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class SchematicsScreen extends StatelessWidget {
  const SchematicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(builder: (cc) {
      return GetBuilder<DataController>(builder: (dc) {
        return AppScaffold(
          selectedIndex: 2,
          title: 'Schematics',
          body: PiScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Output Channels'),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(cc.outputChannels[index].name),
                  ),
                  itemCount: cc.outputChannels.length,
                ),
                const Divider(),
                const Text('Input Channels'),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(cc.inputChannels[index].name),
                  ),
                  itemCount: cc.inputChannels.length,
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}

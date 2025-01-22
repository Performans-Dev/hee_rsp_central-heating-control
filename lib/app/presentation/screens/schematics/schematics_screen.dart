import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchematicsScreen extends StatelessWidget {
  const SchematicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(builder: (cc) {
      return GetBuilder<DataController>(builder: (dc) {
        List<ChannelDefinition> data = [];
        data.addAll(cc.inputChannels);

        data.addAll(cc.outputChannels);

        return AppScaffold(
          selectedIndex: 2,
          title: 'Schematics',
          body: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                  '${data[index].deviceId == 0x00 ? 'Onboard' : 'Ext - ${data[index].deviceId}'}: ${data[index].type.name} ${data[index].pinIndex}'),
              subtitle: data[index].userSelectable
                  ? const Text('heater zone info')
                  : null,
            ),
            itemCount: data.length,
          ),
        );
      });
    });
  }
}

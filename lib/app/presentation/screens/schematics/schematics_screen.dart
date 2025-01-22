import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class SchematicsScreen extends StatelessWidget {
  const SchematicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChannelController>(builder: (cc) {
      return GetBuilder<DataController>(builder: (dc) {
        List<String> data = [];
        data.add('Inputs');
        data.addAll(cc.inputChannels.map((e) => e.name));
        data.add('Outputs');
        data.addAll(cc.outputChannels.map((e) => e.name));

        return AppScaffold(
          selectedIndex: 2,
          title: 'Schematics',
          body: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              title: Text(data[index]),
            ),
            itemCount: data.length,
          ),
        );
      });
    });
  }
}

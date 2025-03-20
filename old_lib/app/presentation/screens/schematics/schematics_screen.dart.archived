import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
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
        data.addAll(cc.inputChannels.where((e) => e.userSelectable));

        data.addAll(cc.outputChannels.where((e) => e.userSelectable));

        return AppScaffold(
          selectedIndex: 2,
          title: 'Schematics',
          body: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                  '${data[index].deviceId == 0x00 ? '' : 'Ext - ${data[index].deviceId}'}: ${data[index].type.name.camelCaseToHumanReadable()} ${data[index].pinIndex}'),
              trailing: data[index].userSelectable
                  ? Text('${dc.getHeaterZoneInfo(data[index].id)}')
                  : null,
            ),
            itemCount: data.length,
          ),
        );
      });
    });
  }
}

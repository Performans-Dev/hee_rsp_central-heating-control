import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/common.dart';
import 'package:central_heating_control/app/data/models/heater_device.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsHeaterListItemWidget extends StatelessWidget {
  const SettingsHeaterListItemWidget({super.key, required this.heater});
  final HeaterDevice heater;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
      final zone = dc.zoneList
          .firstWhereOrNull((element) => element.id == heater.zoneId);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: UiDimens.formRadius),
          tileColor:
              CommonUtils.hexToColor(context, heater.color).withOpacity(0.3),
          title: Text(heater.name),
          subtitle: Text(
              '${heater.type.name.camelCaseToHumanReadable()} - ${heater.connectionType.name.camelCaseToHumanReadable()}'),
          leading: CircleAvatar(
            child: Text(heater.icon.isEmpty ? 'H' : heater.icon.getInitials()),
          ),
          trailing: zone == null ? const Text('no zone') : Text(zone.name),
          onTap: () {
            Buzz.feedback();
            Get.toNamed(
              Routes.settingsDeviceEdit,
              parameters: {
                'id': heater.id.toString(),
              },
            );
          },
        ),
      );
    });
  }
}

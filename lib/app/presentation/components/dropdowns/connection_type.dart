import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/data.dart';

class ConnectionTypeDropdownWidget extends StatelessWidget {
  const ConnectionTypeDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(HeaterDeviceConnectionType?)? onChanged;
  final HeaterDeviceConnectionType? value;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) {
        return ClipRRect(
          borderRadius: UiDimens.formRadius,
          child: DropdownButton<HeaterDeviceConnectionType>(
            underline: Container(), isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 8),
            items: HeaterDeviceConnectionType.values
                .map((e) => DropdownMenuItem<HeaterDeviceConnectionType>(
                      value: e,
                      child: Text(e.name.camelCaseToHumanReadable()),
                    ))
                .toList(),
            onChanged: onChanged,
            value: value,
            borderRadius: UiDimens.formRadius,
            // decoration: InputDecoration(border: UiDimens.formBorder),
          ),
        );
      },
    );
  }
}

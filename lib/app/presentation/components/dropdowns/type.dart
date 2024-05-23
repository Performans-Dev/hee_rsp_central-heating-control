import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypeDropdownWidget extends StatelessWidget {
  const TypeDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(HeaterDeviceType?)? onChanged;
  final HeaterDeviceType? value;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) {
        return ClipRRect(
          borderRadius: UiDimens.formRadius,
          child: DropdownButton<HeaterDeviceType>(
            underline: Container(), isExpanded: true,
            padding: EdgeInsets.symmetric(horizontal: 8),
            items: HeaterDeviceType.values
                .map((e) => DropdownMenuItem<HeaterDeviceType>(
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

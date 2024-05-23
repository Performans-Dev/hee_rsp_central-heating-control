import 'package:central_heating_control/app/core/constants/data.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/models/com_port.dart';
import 'package:flutter/material.dart';

class ComPortDropdownWidget extends StatelessWidget {
  const ComPortDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
    this.group,
  });
  final Function(ComPort?)? onChanged;
  final ComPort? value;
  final GpioGroup? group;

  @override
  Widget build(BuildContext context) {
    final data = UiData.getPortsDropdown(group);
    var selectedValue = value;
    selectedValue ??= data.first;
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<ComPort>(
        underline: Container(), isExpanded: true,
        padding: EdgeInsets.symmetric(horizontal: 8),
        items: data
            .map((e) => DropdownMenuItem<ComPort>(
                  value: e,
                  child: Text(e.title.camelCaseToHumanReadable()),
                ))
            .toList(),
        onChanged: onChanged,
        value: selectedValue,
        borderRadius: UiDimens.formRadius,
        // decoration: InputDecoration(border: UiDimens.formBorder),
      ),
    );
  }
}

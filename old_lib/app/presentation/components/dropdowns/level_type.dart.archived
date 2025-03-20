import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelTypeDropdownWidget extends StatelessWidget {
  const LevelTypeDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
    this.showNoneOption = true,
  });
  final Function(HeaterDeviceLevel?)? onChanged;
  final HeaterDeviceLevel? value;
  final bool showNoneOption;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: UiDimens.formRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: DropdownButton<HeaterDeviceLevel>(
            underline: Container(), isExpanded: true,
            items: HeaterDeviceLevel.values
                .where(
                    (e) => !showNoneOption ? e != HeaterDeviceLevel.none : true)
                .map((e) => DropdownMenuItem<HeaterDeviceLevel>(
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

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/models/zone_definition.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneDropdownWidget extends StatelessWidget {
  const ZoneDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(ZoneDefinition?)? onChanged;
  final ZoneDefinition? value;

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
          child: DropdownButton<ZoneDefinition>(
            underline: Container(), isExpanded: true,

            items: dc
                .getZoneListForDropdown()
                .map((e) => DropdownMenuItem<ZoneDefinition>(
                      value: e,
                      child: Text(e.name),
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

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:flutter/material.dart';

class TimezoneDropdownWidget extends StatelessWidget {
  const TimezoneDropdownWidget({
    super.key,
    required this.data,
    this.onChanged,
    this.value,
  });
  final Function(TimezoneDefinition?)? onChanged;
  final TimezoneDefinition? value;
  final List<TimezoneDefinition> data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<TimezoneDefinition>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: data
            .map((e) => DropdownMenuItem<TimezoneDefinition>(
                  value: e,
                  child: ListTile(
                    title: Text(e.name),
                    trailing: Text(e.zone),
                    leading: Text(e.gmt
                        .replaceAll('(', '')
                        .replaceAll(')', '')
                        .replaceAll('GMT', '')),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

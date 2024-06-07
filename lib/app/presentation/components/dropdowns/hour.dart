import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

class HourDropdownWidget extends StatelessWidget {
  const HourDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(int?)? onChanged;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final hours = List.generate(24, (index) => index);
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<int>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: hours
            .map((e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text('0$e'.right(2)),
                ))
            .toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

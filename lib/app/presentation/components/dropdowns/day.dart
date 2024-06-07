import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class DayDropdownWidget extends StatelessWidget {
  const DayDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(int?)? onChanged;
  final int? value;

  @override
  Widget build(BuildContext context) {
    final days = List.generate(31, (index) => index + 1);
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<int>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: days
            .map((e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text('$e'),
                ))
            .toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

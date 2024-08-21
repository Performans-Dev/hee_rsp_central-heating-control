import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class DayDropdownWidget extends StatelessWidget {
  const DayDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
    this.items,
    this.isExpanded = true,
  });
  final Function(int?)? onChanged;
  final int? value;
  final List<int>? items;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final days = items ?? List.generate(31, (index) => index + 1);
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<int>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: isExpanded,
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

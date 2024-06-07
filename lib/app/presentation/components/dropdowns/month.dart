import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

class MonthDropdownWidget extends StatelessWidget {
  const MonthDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(int?)? onChanged;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<int>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
            .map((e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text('0${e + 1}'.right(2)),
                ))
            .toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

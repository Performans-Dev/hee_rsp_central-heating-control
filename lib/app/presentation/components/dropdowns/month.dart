import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthDropdownWidget extends StatelessWidget {
  const MonthDropdownWidget({
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
    final list = items ?? [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<int>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: isExpanded,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: list
            .map((e) => DropdownMenuItem<int>(
                  value: e,
                  child: Text(DateFormat.MMMM().format(DateTime(0, e))
                      // '0${e + 1}'.right(2)
                      ),
                ))
            .toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

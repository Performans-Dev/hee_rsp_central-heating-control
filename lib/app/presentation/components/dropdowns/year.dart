import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class YearDropdownWidget extends StatelessWidget {
  const YearDropdownWidget({
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
    final years = items ??
        List.generate(100, (index) => DateTime.now().year - index + 50);
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<int>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: isExpanded,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: years
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

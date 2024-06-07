import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class StringDropdownWidget extends StatelessWidget {
  const StringDropdownWidget({
    super.key,
    required this.data,
    this.value,
    this.onChanged,
  });
  final List<String> data;
  final String? value;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<String>(
        borderRadius: UiDimens.formRadius,
        underline: Container(),
        isExpanded: true,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        items: data
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
        value: value,
      ),
    );
  }
}

import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:flutter/material.dart';

class ErrorChannelTypeDropdownWidget extends StatelessWidget {
  const ErrorChannelTypeDropdownWidget({
    super.key,
    this.onChanged,
    this.value,
  });
  final Function(ErrorChannelType?)? onChanged;
  final ErrorChannelType? value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: UiDimens.formRadius,
      child: DropdownButton<ErrorChannelType>(
        underline: Container(), isExpanded: true,
        padding: EdgeInsets.symmetric(horizontal: 8),
        items: ErrorChannelType.values
            .map((e) => DropdownMenuItem<ErrorChannelType>(
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
  }
}

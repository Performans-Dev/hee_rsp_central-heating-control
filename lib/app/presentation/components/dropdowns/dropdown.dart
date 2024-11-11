import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final List<T> data;
  final String labelText;
  final String hintText;
  final T? selectedValue;
  final ValueChanged<T?> onSelected;

  const DropdownWidget({
    required this.data,
    required this.labelText,
    required this.hintText,
    required this.selectedValue,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: UiDimens.formRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              underline: Container(),
              value: selectedValue,
              hint: Text(hintText),
              items: data.map((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: onSelected,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DropdownWidget<T> extends StatelessWidget {
  final List<T> data;
  final T? selectedValue;
  final Function(T?) onSelected;
  final String labelText;
  final String? hintText;
  const DropdownWidget({
    super.key,
    required this.data,
    required this.labelText,
    required this.onSelected,
    this.hintText,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(
          Radius.circular(16),

        ),
      ),
      
    );
  }
}

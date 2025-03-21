import 'package:flutter/material.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';

class HtDropdown<T> extends StatefulWidget {
  final T initialValue;
  final List<T> options;
  final ValueChanged<T> onSelected;
  final String Function(T) labelBuilder;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final Color? selectedItemColor;

  const HtDropdown({
    super.key,
    required this.initialValue,
    required this.options,
    required this.onSelected,
    required this.labelBuilder,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.selectedItemColor,
  });

  @override
  State<HtDropdown<T>> createState() => _HtDropdownState<T>();
}

class _HtDropdownState<T> extends State<HtDropdown<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        widget.borderColor ?? Theme.of(context).colorScheme.primary;
    final borderRadius = widget.borderRadius ?? UiDimens.br12;
    final selectedItemColor = widget.selectedItemColor ??
        Theme.of(context).colorScheme.primaryContainer;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: widget.borderWidth),
        borderRadius: borderRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display the selected value
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              widget.labelBuilder(selectedValue),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          // Dropdown button
          Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: borderColor, width: widget.borderWidth),
              ),
            ),
            child: PopupMenuButton<T>(
              shape: RoundedRectangleBorder(borderRadius: borderRadius),
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_drop_down),
              position: PopupMenuPosition.under,
              offset: const Offset(0, 8),
              constraints: const BoxConstraints(minWidth: 200),
              // This ensures the selected item is visible when the menu opens
              initialValue: selectedValue,
              onSelected: (T value) {
                setState(() {
                  selectedValue = value;
                });
                widget.onSelected(value);
              },
              itemBuilder: (context) => widget.options
                  .map((option) => PopupMenuItem<T>(
                        value: option,
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedValue == option
                                ? selectedItemColor
                                : Colors.transparent,
                            borderRadius: borderRadius,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.labelBuilder(option)),
                              if (selectedValue == option)
                                const Icon(Icons.check, size: 16),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // We no longer need this helper method as we're using the equality operator directly
  // which will use the overridden == operator in our model classes
}

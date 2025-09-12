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
  final bool dense;
  final String? Function(T)? usageInfoBuilder;

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
    this.dense = false,
    this.usageInfoBuilder,
  });

  @override
  State<HtDropdown<T>> createState() => _HtDropdownState<T>();
}

class _HtDropdownState<T> extends State<HtDropdown<T>> {
  late T selectedValue;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  void _showDropdownMenu() async {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final selected = await showMenu<T>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius ?? UiDimens.br12,
      ),
      items: widget.options.map((option) {
        final usageInfo = widget.usageInfoBuilder?.call(option);
        final isUsed = usageInfo != null && usageInfo.isNotEmpty;

        return PopupMenuItem<T>(
          value: option,
          child: Container(
            decoration: BoxDecoration(
              color: selectedValue == option
                  ? widget.selectedItemColor ??
                      Theme.of(context).colorScheme.primaryContainer
                  : Colors.transparent,
              borderRadius: widget.borderRadius ?? UiDimens.br12,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.labelBuilder(option),
                      style: TextStyle(
                        fontStyle: isUsed ? FontStyle.italic : FontStyle.normal,
                        fontWeight: selectedValue == option
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    if (selectedValue == option)
                      const Icon(Icons.check, size: 16),
                  ],
                ),
                if (isUsed)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      usageInfo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    if (selected != null && selected != selectedValue) {
      setState(() {
        selectedValue = selected;
      });
      widget.onSelected(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor =
        widget.borderColor ?? Theme.of(context).colorScheme.primary;
    final borderRadius = widget.borderRadius ?? UiDimens.br12;

    return InkWell(
      key: _key,
      onTap: _showDropdownMenu,
      borderRadius: borderRadius,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.dense ? 1.0 : 12.0,
          vertical: widget.dense ? 1.0 : 10.0,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: widget.borderWidth),
          borderRadius: borderRadius,
        ),
        constraints: null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.labelBuilder(selectedValue),
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(width: widget.dense ? 2 : 4),
            Icon(Icons.arrow_drop_down, size: widget.dense ? 16 : 24),
          ],
        ),
      ),
    );
  }
}

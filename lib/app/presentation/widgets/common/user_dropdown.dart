import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUserLevelDropdownWidget extends StatelessWidget {
  const AppUserLevelDropdownWidget({
    super.key,
    this.initialValue,
    required this.onSelected,
  });
  final int? initialValue;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 0, label: 'Guest'.tr),
        DropdownMenuEntry(value: 1, label: 'User'.tr),
        DropdownMenuEntry(value: 2, label: 'Admin'.tr),
        DropdownMenuEntry(value: 3, label: 'Tech Support'.tr),
      ],
      initialSelection: initialValue,
      onSelected: onSelected,
      enableFilter: false,
      enableSearch: false,
      requestFocusOnTap: false,
    );
  }
}

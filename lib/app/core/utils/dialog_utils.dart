import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';

class DialogUtils {
  static Future<void> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? confirmLabel,
    String? cancelLabel,
  }) async {
    await Get.dialog<void>(
      SizedBox(
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: UiDimens.br12,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        onCancel?.call();
                        Get.back();
                      },
                      child: Text(cancelLabel ?? 'Cancel'.tr),
                    ),
                    TextButton(
                      onPressed: () {
                        onConfirm();
                        Get.back();
                      },
                      child: Text(confirmLabel ?? 'Confirm'.tr),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Future<dynamic> showContentDialog({
    required BuildContext context,
    required Widget content,
  }) async {
    return await Get.dialog<dynamic>(
      SizedBox(
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: UiDimens.br12,
              color: Theme.of(context).colorScheme.surface,
            ),
            child: content,
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  static Future<String?> iconPickerDialog({
    String? initialValue,
    ValueChanged<String>? onSelected,
  }) {
    final iconList =
        Get.find<AppController>().iconList.map((e) => e.url).toList();
    return Get.dialog<String>(
      _IconPickerDialogContent(
        iconList: iconList,
        initialValue: initialValue,
        onSelected: onSelected,
      ),
      barrierDismissible: true,
    );
  }

  static Future<int?> groupPickerDialog({
    int? initialValue,
    ValueChanged<int>? onSelected,
  }) {
    final groups = Get.find<AppController>().groups;
    return Get.dialog<int>(
      _GroupPickerDialogContent(
        groupList: groups,
        initialValue: initialValue,
        onSelected: onSelected,
      ),
      barrierDismissible: true,
    );
  }

  static Future<String?> itemColorPickerDialog({
    String? initialValue,
    ValueChanged<String>? onSelected,
  }) {
    return Get.dialog<String>(
      _ItemColorPickerDialogContent(
        initialValue: initialValue,
        onSelected: onSelected,
      ),
      barrierDismissible: true,
    );
  }

  // TODO: Color picker
}

class _GroupPickerDialogContent extends StatefulWidget {
  final List groupList;
  final int? initialValue;
  final ValueChanged<int>? onSelected;

  const _GroupPickerDialogContent({
    required this.groupList,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<_GroupPickerDialogContent> createState() =>
      _GroupPickerDialogContentState();
}

class _GroupPickerDialogContentState extends State<_GroupPickerDialogContent> {
  int? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pick a Group'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 16),
            widget.groupList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.groupList.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final group = widget.groupList[index];
                        final isSelected = group.id == selected;
                        return ListTile(
                          title: Text(group.name),
                          selected: isSelected,
                          selectedTileColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.08),
                          onTap: () {
                            setState(() => selected = group.id as int?);
                            widget.onSelected?.call(group.id as int);
                            Get.back(result: group.id as int);
                          },
                          trailing: isSelected
                              ? Icon(Icons.check,
                                  color: Theme.of(context).colorScheme.primary)
                              : null,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _ItemColorPickerDialogContent extends StatefulWidget {
  final String? initialValue;
  final ValueChanged<String>? onSelected;

  const _ItemColorPickerDialogContent({
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<_ItemColorPickerDialogContent> createState() =>
      _ItemColorPickerDialogContentState();
}

class _ItemColorPickerDialogContentState
    extends State<_ItemColorPickerDialogContent> {
  late String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    const colors = ItemColor.values;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pick a Color',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 5,
              shrinkWrap: true,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: colors.map((itemColor) {
                final isSelected = selected == itemColor.value;
                return GestureDetector(
                  onTap: () {
                    final value = itemColor.value;
                    widget.onSelected?.call(value);
                    Get.back(result: value);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: itemColor == ItemColor.none
                          ? Colors.transparent
                          : ColorUtils.itemColor(context, itemColor,
                              alpha: 0.3),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 44,
                    height: 44,
                    child: itemColor == ItemColor.none
                        ? Center(
                            child: Text(
                              'None',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.5)),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconPickerDialogContent extends StatefulWidget {
  final List<String> iconList;
  final String? initialValue;
  final ValueChanged<String>? onSelected;

  const _IconPickerDialogContent({
    required this.iconList,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<_IconPickerDialogContent> createState() =>
      _IconPickerDialogContentState();
}

class _IconPickerDialogContentState extends State<_IconPickerDialogContent> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pick an Icon'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 16),
            widget.iconList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.iconList.map((iconUrl) {
                        final isSelected = iconUrl == selected;
                        return GestureDetector(
                          onTap: () {
                            setState(() => selected = iconUrl);
                            widget.onSelected?.call(iconUrl);
                            Get.back(result: iconUrl);
                          },
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: isSelected
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withValues(alpha: 0.08)
                                  : null,
                            ),
                            child: Center(
                              child: SvgPicture.network(
                                iconUrl,
                                width: 32,
                                height: 32,
                                colorFilter: ColorFilter.mode(
                                  Theme.of(context).colorScheme.onSurface,
                                  BlendMode.srcIn,
                                ),
                                placeholderBuilder: (context) => const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

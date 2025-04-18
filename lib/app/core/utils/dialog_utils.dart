import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:central_heating_control/app/data/controllers/app.dart';

class DialogUtils {
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
                    height: 320,
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
                              .withOpacity(0.08),
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

class _IconPickerDialogContent extends StatefulWidget {
  final List<String> iconList;
  final String? initialValue;
  final ValueChanged<String>? onSelected;

  const _IconPickerDialogContent({
    Key? key,
    required this.iconList,
    required this.initialValue,
    required this.onSelected,
  }) : super(key: key);

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
                                      .withOpacity(0.08)
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

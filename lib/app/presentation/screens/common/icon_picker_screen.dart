import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class IconPickerScreen extends StatefulWidget {
  final List<String> iconList;
  final String? initialValue;
  final ValueChanged<String> onSelected;

  const IconPickerScreen({
    super.key,
    required this.iconList,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<IconPickerScreen> createState() => _IconPickerScreenState();
}

class _IconPickerScreenState extends State<IconPickerScreen> {
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick an Icon'.tr)),
      body: widget.iconList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.iconList.map((iconUrl) {
                  final isSelected = iconUrl == selected;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selected = iconUrl);
                      widget.onSelected(iconUrl);
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
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupLayout extends StatelessWidget {
  const SetupLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.isExpanded = false,
    this.nextLabel,
    this.nextCallback,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final bool isExpanded;
  final String? nextLabel;
  final GestureTapCallback? nextCallback;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      final list = sc.setupSequenceList;
      final currentSequence =
          sc.setupSequenceList.firstWhereOrNull((e) => !e.isCompleted);
      final currentIndex =
          currentSequence == null ? 0 : list.indexOf(currentSequence);
      return Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SetupHeaderWidget(title: title),
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 130,
                    height: double.infinity,
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    index == currentIndex
                                        ? Icons.radio_button_checked
                                        : sc.setupSequenceList[index]
                                                .isCompleted
                                            ? Icons.check
                                            : Icons.radio_button_unchecked,
                                    size: 16,
                                    color: index == currentIndex
                                        ? Colors.orange
                                        : sc.setupSequenceList[index]
                                                .isCompleted
                                            ? Colors.green
                                            : Colors.grey,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      sc.setupSequenceList[index].title,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            itemCount: sc.setupSequenceList.length,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 20,
                          ),
                          child: LinearProgressIndicator(
                            value: sc.progress,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (subtitle != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              subtitle!,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        if (subtitle != null)
                          const Divider(
                            height: 1,
                            indent: 20,
                            endIndent: 20,
                          ),
                        if (subtitle != null) const SizedBox(height: 12),
                        Expanded(
                          child: isExpanded
                              ? child
                              : PiScrollView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 80),
                                  child: child,
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20, top: 4),
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: 50,
                            child: OutlinedButton(
                              onPressed: nextCallback,
                              child: nextLabel == null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(width: 8),
                                        Text('Next'.tr),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.chevron_right),
                                      ],
                                    )
                                  : Text(nextLabel!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

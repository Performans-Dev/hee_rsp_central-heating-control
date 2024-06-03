import 'package:flutter/material.dart';

class WizardPageContentWidget extends StatelessWidget {
  const WizardPageContentWidget({
    super.key,
    required this.children,
    this.title,
    this.padding,
  });
  final EdgeInsets? padding;
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 60, vertical: 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ...children,
        ],
      ),
    );
  }
}

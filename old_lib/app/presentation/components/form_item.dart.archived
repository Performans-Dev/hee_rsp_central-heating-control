import 'package:central_heating_control/app/presentation/widgets/form_label.dart';
import 'package:flutter/material.dart';

class FormItemComponent extends StatelessWidget {
  const FormItemComponent({
    super.key,
    required this.label,
    required this.child,
  });
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormLabelWidget(label: label),
        child,
      ],
    );
  }
}

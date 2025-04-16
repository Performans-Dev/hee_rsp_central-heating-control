import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class HtTextField extends StatelessWidget {
  const HtTextField({super.key, this.initialValue, this.onTap});
  final String? initialValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: UiDimens.br12,
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 42),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: UiDimens.br12,
          border: Border.all(
              color: Theme.of(context)
                      .inputDecorationTheme
                      .border
                      ?.borderSide
                      .color ??
                  Theme.of(context).colorScheme.onSurface),
        ),
        child: Text(initialValue ?? ''),
      ),
    );
  }
}

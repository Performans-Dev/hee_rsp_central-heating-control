import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class ListTileButton extends StatelessWidget {
  const ListTileButton({
    super.key,
    required this.title,
    this.description,
    this.onTap,
    this.trailing,
    this.leading,
  });
  final String title;
  final String? description;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: description == null ? null : Text(description!),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      leading: leading,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: UiDimens.br12,
      ),
      tileColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }
}

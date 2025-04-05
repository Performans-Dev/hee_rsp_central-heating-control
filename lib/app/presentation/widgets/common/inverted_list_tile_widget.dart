import 'package:flutter/material.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';

/// A custom ListTile widget that inverts the text styles of title and subtitle.
///
/// This widget is similar to a standard ListTile but swaps the text styles
/// between the title and subtitle for scenarios where visual hierarchy needs
/// to be reversed.
class InvertedListTileWidget extends StatelessWidget {
  const InvertedListTileWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.tileColor,
    this.shape,
    this.contentPadding,
    this.dense,
    this.enabled = true,
  });

  /// The primary content of the list tile.
  /// Will be displayed with subtitle text style.
  final Widget title;

  /// Additional content displayed below the title.
  /// Will be displayed with title text style.
  final Widget? subtitle;

  /// A widget to display before the title.
  final Widget? leading;

  /// A widget to display after the title.
  final Widget? trailing;

  /// Called when the user taps this list tile.
  final VoidCallback? onTap;

  /// The color of the tile's background.
  final Color? tileColor;

  /// The shape of the tile's [InkWell].
  final ShapeBorder? shape;

  /// The tile's internal padding.
  final EdgeInsetsGeometry? contentPadding;

  /// Whether this list tile is part of a vertically dense list.
  final bool? dense;

  /// Whether this list tile is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context).textTheme.labelSmall;
    final TextStyle? subtitleStyle = Theme.of(context).textTheme.titleMedium;

    return ListTile(
      title: DefaultTextStyle(
        style: titleStyle ?? const TextStyle(),
        child: title,
      ),
      subtitle: subtitle != null
          ? DefaultTextStyle(
              style: subtitleStyle ?? const TextStyle(),
              child: subtitle!,
            )
          : null,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      tileColor: tileColor,
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: UiDimens.br12,
          ),
      contentPadding: contentPadding,
      dense: dense,
      enabled: enabled,
    );
  }
}

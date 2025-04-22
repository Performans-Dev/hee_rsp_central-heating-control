import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DeviceIconWidget extends StatelessWidget {
  const DeviceIconWidget(
      {super.key, this.icon, this.size = 24, this.background, this.radius});
  final String? icon;
  final double? size;
  final Color? background;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor:
          background ?? Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      child: icon != null && icon!.isNotEmpty
          ? SizedBox(
              width: size,
              height: size,
              child: SvgPicture.network(
                icon!,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onPrimaryContainer,
                  BlendMode.srcIn,
                ),
              ))
          : const Icon(Icons.ac_unit),
    );
  }
}

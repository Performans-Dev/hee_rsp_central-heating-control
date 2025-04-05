import 'dart:math' as math;
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:flutter/material.dart';

enum CardSize { mini, small, medium, large }

class CardButtonWidget extends StatelessWidget {
  const CardButtonWidget({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.color = Colors.white,
    this.size = CardSize.medium,
    this.subtitle,
  });
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final CardSize size;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final double width = size == CardSize.mini
        ? 72
        : size == CardSize.small
            ? 160
            : size == CardSize.medium
                ? 218
                : 336;

    final double height = size == CardSize.mini
        ? 80
        : size == CardSize.small
            ? 150
            : size == CardSize.medium
                ? 190
                : 230;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: UiDimens.br12),
      child: InkWell(
        borderRadius: UiDimens.br12,
        onTap: onTap,
        child: ClipRRect(
          borderRadius: UiDimens.br12,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.4),
                color.withValues(alpha: 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            width: width,
            height: height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.rotate(
                    angle: -math.pi / 8.0,
                    child: Icon(
                      icon,
                      color: Colors.white.withValues(alpha: 0.15),
                      size: height - 20,
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.7, -0.7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: (size == CardSize.mini
                              ? Theme.of(context).textTheme.bodyMedium
                              : Theme.of(context).textTheme.headlineSmall)
                          ?.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black38,
                            blurRadius: 12,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (subtitle != null)
                  Align(
                    alignment: const Alignment(-0.7, 0.9),
                    child: Text(
                      subtitle!,
                      style: (size == CardSize.mini
                              ? Theme.of(context).textTheme.labelSmall
                              : Theme.of(context).textTheme.labelMedium)
                          ?.copyWith(
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                            color: Colors.black38,
                            blurRadius: 12,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

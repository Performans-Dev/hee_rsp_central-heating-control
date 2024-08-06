import 'package:flutter/material.dart';

class ConnectionCardWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const ConnectionCardWidget({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        hoverColor: Theme.of(context).hoverColor,
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minWidth: 150, minHeight: 100),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.67,
                child: Icon(
                  icon,
                  size: 48,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupHeaderWidget extends StatelessWidget {
  const SetupHeaderWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      height: 64,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const LogoWidget(
              size: 180,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                    onPressed: () => Get.toNamed(Routes.piInfo),
                    icon: const Icon(Icons.info_outline))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

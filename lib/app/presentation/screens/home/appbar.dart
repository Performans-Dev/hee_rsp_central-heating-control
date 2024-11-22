import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/indicator_network.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  HomeAppBar({super.key, this.title});
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final AppController app = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      centerTitle: false,
      actions: [
        const SizedBox(width: 8),
        Icon(
          Icons.warning,
          color: app.hasError ? Colors.red : null,
        ),
        const SizedBox(width: 4),
        const AppBarNetworkIndicator(),
        const SizedBox(width: 8),
        const DateTextWidget(),
        const SizedBox(width: 8),
      ],
      title: InkWell(
        onDoubleTap: () async {
          await windowManager.minimize();
        },
        child: Text(title ?? 'Central Controller'),
      ),

      elevation: 16,
    );
  }
}

import 'package:central_heating_control/app/presentation/components/indicator_network.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, this.title});
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // automaticallyImplyLeading: false,
      centerTitle: false,
      actions: const [
        SizedBox(width: 8),
        Icon(Icons.warning),
        SizedBox(width: 4),
        AppBarNetworkIndicator(),
        SizedBox(width: 8),
        DateTextWidget(),
        SizedBox(width: 8),
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

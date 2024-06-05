import 'package:central_heating_control/app/presentation/components/indicator_network.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
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
        Icon(Icons.warning),
        SizedBox(width: 4),
        AppBarNetworkIndicator(),
        SizedBox(width: 8),
        DateTextWidget(),
        SizedBox(width: 8),
      ],
      title: title != null
          ? Text(title!)
          : InkWell(
              onDoubleTap: () async {
                await windowManager.minimize();
              },
              child: const LogoWidget(size: 140),
            ),

      // title != null
      //     ? Text(
      //         title!,
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       )
      //     : InkWell(
      //         onDoubleTap: () async {
      //           await windowManager.minimize();
      //         },
      //         child: LogoWidget(size: 140),
      //       ),
      // actions: const [
      //   Icon(Icons.warning),
      //   SizedBox(width: 4),
      //   Icon(Icons.lan_outlined),
      //   SizedBox(width: 4),
      //   Icon(Icons.wifi),
      //   SizedBox(width: 16),
      // ],
      // leading: Container(
      //   height: kToolbarHeight,
      //   alignment: Alignment.centerLeft,
      //   margin: const EdgeInsets.only(left: 20),
      //   child: const DateTextWidget(),
      // ),
      // leadingWidth: 200,
      elevation: 16,
    );
  }
}

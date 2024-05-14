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
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onDoubleTap: () async {
              await windowManager.minimize();
            },
            child: LogoWidget(size: 140),
          ),
          Container(
            height: kToolbarHeight,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 20),
            child: const DateTextWidget(),
          ),
          Container(
            width: 140,
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.warning),
                SizedBox(width: 4),
                Icon(Icons.lan_outlined),
                SizedBox(width: 4),
                Icon(Icons.wifi),
              ],
            ),
          ),
        ],
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

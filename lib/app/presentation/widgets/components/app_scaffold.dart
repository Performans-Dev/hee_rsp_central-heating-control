import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {super.key, required this.body, this.appBar, this.selectedMenuIndex = 0});
  final Widget body;
  final AppBar? appBar;
  final int selectedMenuIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          GetBuilder<AppController>(builder: (app) {
            return NavigationRail(
              destinations: [
                NavigationRailDestination(
                    icon: Icon(Icons.dashboard), label: Text('Home'.tr)),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('Settings'.tr)),
                NavigationRailDestination(
                    icon: Icon(Icons.lock), label: Text('Lock'.tr)),
              ],
              selectedIndex: selectedMenuIndex,
              labelType: NavigationRailLabelType.all,
              extended: false,
              onDestinationSelected: (index) {},
              leading: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: SvgPicture.asset(
                    app.preferences.isDark
                        ? UiAssets.appIconDark
                        : UiAssets.appIconLight,
                  ),
                ),
              ),
            );
          }),
          const VerticalDivider(),
          body,
        ],
      ),
    );
  }
}

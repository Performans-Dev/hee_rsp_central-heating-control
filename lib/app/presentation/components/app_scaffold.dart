import 'dart:math' as math;
import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:central_heating_control/app/presentation/widgets/com_indicator_led.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.selectedIndex = 0,
    // this.backButton = false,
    this.title,
  });
  final Widget body;
  final int selectedIndex;
  // final bool backButton;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return Scaffold(
          //appBar: const HomeAppBar(),
          body: Row(
            children: [
              NavigationRail(
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.dashboard),
                    label: Text('Zones'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.access_alarm),
                    label: Text('Functions'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.auto_mode),
                    label: Text('Mode'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.lock),
                    label: Text('Lock'),
                  ),
                ],
                selectedIndex: selectedIndex,
                labelType: NavigationRailLabelType.all,
                extended: false,
                leading: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      app.themeMode == ThemeMode.dark
                          ? UiAssets.appIconDark
                          : UiAssets.appIconLight,
                    ),
                  ),
                ),
                trailing: SizedBox(
                  width: 56,
                  height: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Divider(height: 8),
                      Text(
                        app.loggedInAppUser?.username ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.87),
                        ),
                      ),
                      const Divider(height: 8),
                      const ComIndicatorLedWidget(),
                      const Divider(height: 8),
                      Text(
                        app.deviceInfo?.appVersion ?? 'N/A',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.color
                                  ?.withOpacity(0.4),
                            ),
                      ),
                    ],
                  ),
                ),
                onDestinationSelected: (value) async {
                  switch (value) {
                    case 0:
                      NavController.toHome();
                      break;
                    case 1:
                      // Get.toNamed(Routes.daySummaryScreen);
                      break;
                    case 2:
                      //TODO: replace this with change heating mode
                      app.nextThemeMode();
                      break;
                    case 3:
                      NavController.toSettings();
                      break;
                    case 4:
                      NavController.lock();
                      break;
                    default:
                      break;
                  }
                },
              ),
              const VerticalDivider(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HomeAppBar(title: title),
                    Expanded(
                      child: body,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

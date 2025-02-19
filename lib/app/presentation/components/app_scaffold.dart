import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/data/routes/pages.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:central_heating_control/app/presentation/widgets/com_indicator_led.dart';
import 'package:central_heating_control/main.dart';
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
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.dashboard),
                    label: Text('Zones'),
                  ),
                  NavigationRailDestination(
                    icon: const Icon(Icons.access_alarm),
                    label: const Text('Functions'),
                    disabled: !enabledFunctions,
                  ),
                  // const NavigationRailDestination(
                  //   icon: Icon(Icons.auto_mode),
                  //   label: Text('Mode'),
                  // ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.shape_line_outlined),
                    label: Text('Scheme'),
                  ),

                  const NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(
                      Icons.lock,
                      color: _isExcludedRoute(context) ? Colors.red : null,
                    ),
                    label: const Text('Lock'),
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
                      app.preferencesDefinition.themeModeIndex ==
                              ThemeMode.values.indexOf(ThemeMode.dark)
                          ? UiAssets.appIconDark
                          : UiAssets.appIconLight,
                    ),
                  ),
                ),
                trailing: InkWell(
                  onTap: () => NavController.toInfo(context),
                  child: SizedBox(
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
                                .withValues(alpha: 0.87),
                          ),
                        ),
                        const Divider(height: 8),
                        const ComIndicatorLedWidget(),
                        const Divider(height: 8),
                        Text(
                          app.deviceInfo?.appVersion ?? 'N/A',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.color
                                        ?.withValues(alpha: 0.4),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                onDestinationSelected: (value) async {
                  switch (value) {
                    case 0:
                      NavController.toHome();
                      break;
                    case 1:
                      // Get.toNamed(Routes.daySummaryScreen);
                      // Get.toNamed(Routes.settingsPreferencesAdvanced);
                      Get.toNamed(Routes.functions);
                      break;
                    case 2:
                      Get.toNamed(Routes.schematics);
                      break;
                    case 3:
                      NavController.toSettings();
                      break;
                    case 4:
                      NavController.lock(context);
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

  bool _isExcludedRoute(context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    return autoLockExcludedRoutes.contains(currentRoute);
  }
}

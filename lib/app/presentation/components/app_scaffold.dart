import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
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
                    child: SvgPicture.asset(app.isDarkMode
                        ? UiAssets.appIconDark
                        : UiAssets.appIconLight),
                  ),
                ),
                onDestinationSelected: (value) async {
                  switch (value) {
                    case 0:
                      NavController.toHome();
                      break;
                    case 1:
                      // final result = await NavController.showFunctionsDialog(
                      //     context: context);
                      // print("//TODO: $result");
                      final result = await Get.toNamed(Routes.onScreenKeyboard,
                          parameters: {'label': 'Test'});
                      print(result);
                      break;
                    case 2:
                      //TODO: replace this with change heating mode
                      app.toggleDarkMode();
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

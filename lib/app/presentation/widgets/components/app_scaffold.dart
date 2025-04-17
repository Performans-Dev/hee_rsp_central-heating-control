import 'package:central_heating_control/app/core/constants/assets.dart';
import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/presentation/widgets/common/appuser_name_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/datetime_display.dart';
import 'package:central_heating_control/app/presentation/widgets/common/io_indicator_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/log_warning_indicator_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/network_indicator_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/version_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.selectedMenuIndex = 0,
    this.hasBackAction = false,
    this.floatingActionButton,
  });
  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final int selectedMenuIndex;
  final bool hasBackAction;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        appBar: AppBar(
          title: hasBackAction
              ? Container(
                  margin: const EdgeInsets.only(left: 2),
                  child: Text(title ?? ''))
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 24, left: 4),
                      child: Center(
                        child: SvgPicture.asset(
                          app.preferences.isDark
                              ? UiAssets.appIconDark
                              : UiAssets.appIconLight,
                        ),
                      ),
                    ),
                    if (title != null) Text(title!),
                  ],
                ),
          centerTitle: false,
          actions: actions ??
              [
                const LogWarningIndicatorWidget(),
                const NetworkStatusIndicatorWidget(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: InkWell(
                    borderRadius: UiDimens.br12,
                    onTap: () => Get.toNamed(Routes.preferencesDatetimeFormat),
                    child: const LiveDateTimeDisplay(
                      fontSize: 12,
                      force2Line: true,
                    ),
                  ),
                )
              ],
          leading: hasBackAction
              ? Container(
                  width: kToolbarHeight,
                  height: kToolbarHeight,
                  margin: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Get.back(),
                    splashRadius: kToolbarHeight,
                  ),
                )
              : null,
          leadingWidth: kToolbarHeight + 8,
        ),
        body: Row(
          children: [
            NavigationRail(
              destinations: [
                NavigationRailDestination(
                    icon: const Icon(Icons.dashboard), label: Text('Home'.tr)),
                NavigationRailDestination(
                    icon: const Icon(Icons.question_mark),
                    label: Text('Rules'.tr)),
                NavigationRailDestination(
                    icon: const Icon(Icons.question_mark),
                    label: Text('Scheme'.tr)),
                NavigationRailDestination(
                    icon: const Icon(Icons.settings),
                    label: Text('Settings'.tr)),
                NavigationRailDestination(
                    icon: const Icon(Icons.lock), label: Text('Lock'.tr)),
              ],
              selectedIndex: selectedMenuIndex,
              labelType: NavigationRailLabelType.all,
              extended: false,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    Get.offAllNamed(Routes.home);
                    break;
                  case 3:
                    Get.toNamed(Routes.settings);
                    break;
                  default:
                    break;
                }
              },
              trailing: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(),
                  AppUserNameWidget(),
                  Divider(
                    height: 6,
                  ),
                  IoIndicatorWidget(),
                  Divider(
                    height: 6,
                  ),
                  VersionInfoWidget()
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 0.4),
                        Theme.of(context)
                            .colorScheme
                            .secondaryContainer
                            .withValues(alpha: 0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )),
                  ),
                  Container(
                      constraints: const BoxConstraints.expand(), child: body),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: floatingActionButton,
      );
    });
  }
}

import 'package:central_heating_control/app/presentation/screens/developer/widgets/datetime.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/language.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/lock_screen.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/network.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/preferences_info.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/theme.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/timezone.dart';
import 'package:flutter/material.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Settings'),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            DevPreferencesInfoWidget(),
            DevThemeSwitcherWidget(),
            DevLockScreenWidget(),
            DevLanguageSwitcherWidget(),
            DevTimezoneSwitcherWidget(),
            DevDateTimeFormatSwitcherWidget(),
            Divider(),
            DevNetworkInfoWidget(),
            Divider(),
          ],
        ),
      ),
    );
  }
}

import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreferencesScreenSaverScreen extends StatefulWidget {
  const PreferencesScreenSaverScreen({super.key});

  @override
  State<PreferencesScreenSaverScreen> createState() =>
      _PreferencesScreenSaverScreenState();
}

class _PreferencesScreenSaverScreenState
    extends State<PreferencesScreenSaverScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Screen Saver'.tr,
      hasBackAction: true,
      selectedMenuIndex: 1,
      body: Center(
        child: Text('ss'),
      ),
    );
  }
}

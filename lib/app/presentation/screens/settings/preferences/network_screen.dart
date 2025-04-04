import 'package:flutter/material.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:get/get_utils/get_utils.dart';

class PreferencesNetworkConnectionsScreen extends StatefulWidget {
  const PreferencesNetworkConnectionsScreen({super.key});

  @override
  State<PreferencesNetworkConnectionsScreen> createState() =>
      _PreferencesNetworkConnectionsScreenState();
}

class _PreferencesNetworkConnectionsScreenState
    extends State<PreferencesNetworkConnectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Network Connections'.tr,
      hasBackAction: true,
      selectedMenuIndex: 1,
      body: Center(
        child: Text('nc'),
      ),
    );
  }
}

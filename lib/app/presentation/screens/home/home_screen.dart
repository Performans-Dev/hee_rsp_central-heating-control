import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// this is the dashboard
///
/// displays a list of groups
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: const Center(
        child: Text('h'),
      ),
      title: 'Home'.tr,
    );
  }
}

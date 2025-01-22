import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class SchematicsScreen extends StatelessWidget {
  const SchematicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      selectedIndex: 2,
      title: 'Schematics',
      body: Text('data'),
    );
  }
}

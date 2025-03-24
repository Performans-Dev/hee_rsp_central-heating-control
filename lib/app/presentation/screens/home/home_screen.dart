import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('h'),
      ),
    );
  }
}

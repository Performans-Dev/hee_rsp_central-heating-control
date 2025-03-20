import 'package:central_heating_control/app/presentation/screens/developer/widgets/language.dart';
import 'package:central_heating_control/app/presentation/screens/developer/widgets/theme.dart';
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
            DevThemeSwitcherWidget(),
            DevLanguageSwitcherWidget(),
          ],
        ),
      ),
    );
  }
}

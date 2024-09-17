import 'package:flutter/material.dart';

class SettingsPreferencesAdvancedDiagnosticsScreen extends StatelessWidget {
  const SettingsPreferencesAdvancedDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnostics'),
      ),
      body: Center(
        child: Text('Settings / Preferences / Advanced / Diagnostics'),
      ),
    );
  }
}

import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsHeaterEditScreen extends StatelessWidget {
  const SettingsHeaterEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(
      builder: (dc) => AppScaffold(
        title: 'Heaters',
        selectedIndex: 3,
        body: SingleChildScrollView(),
      ),
    );
  }
}

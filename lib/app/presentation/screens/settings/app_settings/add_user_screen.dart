import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/content.dart';
import 'package:central_heating_control/app/presentation/components/hardware_buttons.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsAddUserScreen extends StatefulWidget {
  const SettingsAddUserScreen({super.key});

  @override
  State<SettingsAddUserScreen> createState() => _SettingsAddUserScreenState();
}

class _SettingsAddUserScreenState extends State<SettingsAddUserScreen> {
  bool isAdminChecked = false;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => Scaffold(
        appBar: HomeAppBar(
          title: 'Settings - Add New User',
        ),
        body: Stack(
          children: [
            ContentWidget(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: 'Name Surname'),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          labelText: 'Pin Code'),
                    ),
                    SizedBox(height: 8),
                    SwitchListTile(
                      value: isAdminChecked,
                      onChanged: (v) {
                        setState(() {
                          isAdminChecked = v;
                        });
                      },
                      title: Text('Admin'),
                      subtitle: Text(
                          'Switch on if you want to access this user to settings screen'),
                      isThreeLine: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ],
                ),
              ),
            ),
            HwBtnCancel(),
            HwBtnSave(
              callback: () {},
            ),
          ],
        ),
      ),
    );
  }
}

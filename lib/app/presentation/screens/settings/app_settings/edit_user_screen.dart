import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/content.dart';
import 'package:central_heating_control/app/presentation/components/hardware_buttons.dart';
import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class SettingsEditUserScreen extends StatefulWidget {
  final AppUser? user;
  const SettingsEditUserScreen({
    super.key,
    this.user,
  });

  @override
  State<SettingsEditUserScreen> createState() => _SettingsEditUserScreenState();
}

class _SettingsEditUserScreenState extends State<SettingsEditUserScreen> {
  late final TextEditingController nameController;
  late final TextEditingController pinController;
  bool isAdminChecked = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    pinController = TextEditingController();
    if (widget.user != null) {
      nameController.text = widget.user!.username;
      pinController.text = widget.user!.pin;
      isAdminChecked = widget.user!.isAdmin;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => AppScaffold(
        title: 'Settings - Add New User',
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              // color: Theme.of(context).focusColor,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(20),
              child: Text(
                'Settings / Add New User',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'Name Surname',
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: pinController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        labelText: 'Pin Code',
                      ),
                      keyboardType: TextInputType.number,
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
            saveButton
          ],
        ),
      ),
    );
  }

  Widget get saveButton => Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: ElevatedButton(
          child: Text("Save"),
          onPressed: () async {
            AppController ac = Get.find();
            final AppUser appUser = AppUser(
              id: widget.user?.id,
              username: nameController.text,
              pin: pinController.text,
              isAdmin: isAdminChecked,
            );
            if (appUser.username.isEmpty) {
              DialogUtils.snackbar(
                context: context,
                message: 'Name Surname required.',
                type: SnackbarType.warning,
              );
              return;
            }
            if (appUser.pin.length != 6) {
              print('pin required');
              return;
            }

            final result = await DbProvider.db.updateUser(appUser);
            if (result > 0) {
              //success
              print('user added');
            } else {
              print('db error');
            }
          },
        ),
      );
}

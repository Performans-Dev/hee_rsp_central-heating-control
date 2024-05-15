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

class SettingsAddUserScreen extends StatefulWidget {
  const SettingsAddUserScreen({super.key});

  @override
  State<SettingsAddUserScreen> createState() => _SettingsAddUserScreenState();
}

class _SettingsAddUserScreenState extends State<SettingsAddUserScreen> {
  late final TextEditingController nameController;
  late final TextEditingController pinController;
  bool isAdminChecked = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    pinController = TextEditingController();
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
              padding: const EdgeInsets.all(20),
              child: Text(
                'Settings / Add New User',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: isAdminChecked,
                      onChanged: (v) {
                        setState(() {
                          isAdminChecked = v;
                        });
                      },
                      title: const Text('Admin'),
                      subtitle: const Text(
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
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          child: const Text("Save"),
          onPressed: () async {
            final AppUser appUser = AppUser(
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

            final result = await DbProvider.db.addUser(appUser);
            AppController app = Get.find();
            app.populateUserList();

            if (result > 0) {
              //success
              print('user added');
            } else {
              print('db error');
            }
            Get.back();
          },
        ),
      );
}

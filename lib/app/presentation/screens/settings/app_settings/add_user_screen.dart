import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
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
            const BreadcrumbWidget(
              title: 'Settings / Add New User',
            ),
            Expanded(
              child: PiScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputWidget(
                      labelText: "Name Surname",
                      controller: nameController,
                    ),
                    TextInputWidget(
                      labelText: "'Pin Code'",
                      controller: pinController,
                    ),
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
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [cancelButton, const SizedBox(width: 12), saveButton],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget get saveButton => ElevatedButton(
        onPressed: onSaveButonPressed,
        child: const Text("Save"),
      );
  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );

  Future<void> onSaveButonPressed() async {
    final AppUser appUser = AppUser(
      id: -1,
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
      if (!mounted) return;
      DialogUtils.snackbar(
        action: SnackBarAction(
          label: "Retry",
          onPressed: onSaveButonPressed,
        ),
        context: context,
        message: "Pin code must be 6 chars",
        type: SnackbarType.warning,
      );
      return;
    }
    AppController app = Get.find();

    final result = await DbProvider.db.addUser(appUser);
    app.populateUserList();

    if (result > 0) {
      //success
      if (!mounted) return;

      DialogUtils.snackbar(
        context: context,
        message: "User has been registered successfully",
        type: SnackbarType.success,
      );
    } else {
      if (!mounted) return;
      DialogUtils.snackbar(
        action: SnackBarAction(
          label: "Retry",
          onPressed: onSaveButonPressed,
        ),
        context: context,
        message: "There was a problem registering the user.",
        type: SnackbarType.error,
      );
    }
    Get.back();
  }
}

import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsUserAddScreen extends StatefulWidget {
  const SettingsUserAddScreen({super.key});

  @override
  State<SettingsUserAddScreen> createState() => _SettingsUserAddScreenState();
}

class _SettingsUserAddScreenState extends State<SettingsUserAddScreen> {
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
            Expanded(
              child: PiScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    TextInputWidget(
                      labelText: 'Name, Surname',
                      controller: nameController,
                      type: OSKInputType.name,
                      minLength: 3,
                      maxLenght: 28,
                    ),
                    const SizedBox(height: 12),
                    TextInputWidget(
                      isNewUser: true,
                      isPin: true,
                      labelText: 'PIN Code'.tr,
                      controller: pinController,
                      type: OSKInputType.number,
                      obscureText: true,
                      obscuringCharacter: '*',
                      minLength: 6,
                      maxLenght: 6,
                    ),
                    const SizedBox(height: 12),
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
      level: isAdminChecked ? AppUserLevel.admin : AppUserLevel.user,
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
    final result = await app.addUser(user: appUser);

    if (result.success) {
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
        message: result.message ?? "There was a problem registering the user.",
        type: SnackbarType.error,
      );
    }
    Get.back();
  }
}

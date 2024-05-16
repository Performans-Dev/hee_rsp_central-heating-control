import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsEditUserScreen extends StatefulWidget {
  const SettingsEditUserScreen({
    super.key,
  });

  @override
  State<SettingsEditUserScreen> createState() => _SettingsEditUserScreenState();
}

class _SettingsEditUserScreenState extends State<SettingsEditUserScreen> {
  late final TextEditingController nameController;
  late final TextEditingController pinController;
  late AppUser? user;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    user = Get.arguments?[0];

    nameController = TextEditingController(text: user?.username)
      ..addListener(() {
        user?.username = nameController.text;
      });
    pinController = TextEditingController(text: user?.pin)
      ..addListener(() {
        user?.pin = pinController.text;
      });
  }

  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      Future.delayed(Duration.zero, () => Get.back());
    }
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputWidget(
                      labelText: "Name Surname",
                      controller: nameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 8),
                    TextInputWidget(
                      labelText: "Pin Code",
                      controller: pinController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      value: user!.isAdmin,
                      onChanged: (v) {
                        setState(() {
                          user!.isAdmin = v;
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
        onPressed: busy ? null : onSaveButonPressed,
        child: Text(busy ? 'Saving...' : "Save"),
      );
  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );

  Future<void> onSaveButonPressed() async {
    BuildContext ctx = context;
    if (user!.username.isEmpty) {
      DialogUtils.snackbar(
        context: context,
        message: 'Name Surname required.',
        type: SnackbarType.warning,
      );
      return;
    }
    if (user!.pin.length != 6) {
      DialogUtils.snackbar(
        context: context,
        message: 'Pin code must be 6 chars',
        type: SnackbarType.warning,
      );
      return;
    }

    setState(() => busy = true);

    final result = await DbProvider.db.updateUser(user!);
    final AppController app = Get.find();
    await app.populateUserList();
    setState(() => busy = false);
    if (ctx.mounted) {
      if (result > 0) {
        DialogUtils.snackbar(
          context: ctx,
          message: 'User updated.',
          type: SnackbarType.success,
        );
        Get.back();
      } else {
        DialogUtils.snackbar(
          context: ctx,
          action: SnackBarAction(
            label: "Retry",
            onPressed: onSaveButonPressed,
          ),
          message: 'Unexpected error occured',
          type: SnackbarType.error,
        );
      }
    }
  }
}

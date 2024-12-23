import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/providers/db.dart';

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SettingsUserListScreen extends StatelessWidget {
  SettingsUserListScreen({super.key});
  bool canAccess(AppUserLevel loggedInUserLevel, AppUserLevel targetUserLevel) {
    final accessControl = {
      AppUserLevel.techSupport: [AppUserLevel.developer],
      AppUserLevel.admin: [AppUserLevel.developer, AppUserLevel.techSupport],
      AppUserLevel.user: [
        AppUserLevel.developer,
        AppUserLevel.techSupport,
        AppUserLevel.admin
      ],
    };

    final restrictedLevels = accessControl[loggedInUserLevel] ?? [];
    return !restrictedLevels.contains(targetUserLevel);
  }

  final DbProvider db = DbProvider.db;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) => AppScaffold(
        title: "Users",
        selectedIndex: 3,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (app.appUserList[index].level == AppUserLevel.developer &&
                      app.loggedInAppUser?.level != AppUserLevel.developer) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        child:
                            Text(app.appUserList[index].username.getInitials()),
                      ),
                      title: Text(app.appUserList[index].username),
                      subtitle: Text(app.appUserList[index].level.name
                          .camelCaseToHumanReadable()),
                      trailing: !canAccess(
                              app.loggedInAppUser?.level ?? AppUserLevel.user,
                              app.appUserList[index].level)
                          ? null
                          : PopupMenuButton(
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Change Name"),
                                        Icon(Icons.drive_file_rename_outline),
                                      ],
                                    ),
                                    onTap: () async {
                                      final result =
                                          await OnScreenKeyboard.show(
                                        context: context,
                                        label: 'Name, Surname',
                                        initialValue:
                                            app.appUserList[index].username,
                                        type: OSKInputType.name,
                                      );
                                      if (result != null) {
                                        var u = app.appUserList[index];
                                        u.username = result;
                                        await db.updateUser(u);
                                        if (context.mounted) {
                                          DialogUtils.snackbar(
                                            type: SnackbarType.success,
                                            context: context,
                                            message: 'Username updated',
                                          );
                                        }
                                      }
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Change Password"),
                                        Icon(Icons.key),
                                      ],
                                    ),
                                    onTap: () async {
                                      /*   final result = await OnScreenKeyboard.show(
                                context: context,
                                label: 'Password',
                                initialValue: app.appUserList[index].pin,
                                type: OSKInputType.number,
                                maxLength: 6,
                                minLength: 6,
                              ); */
                                      final result = await NavController.toPin(
                                          context: context,
                                          username:
                                              app.appUserList[index].username);
                                      if (result != null) {
                                        var u = app.appUserList[index];
                                        u.pin = result;
                                        await db.updateUser(u);
                                        if (context.mounted) {
                                          DialogUtils.snackbar(
                                            type: SnackbarType.success,
                                            context: context,
                                            message: 'Password updated',
                                          );
                                        }
                                      }
                                      //
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Delete"),
                                        Icon(Icons.delete),
                                      ],
                                    ),
                                    onTap: () => onDeleteUserPressed(
                                      context: context,
                                      index: index,
                                    ),
                                  ),
                                ];
                              },
                            ),
                    ),
                  );
                },
                itemCount: app.appUserList.length,
              ),
            ),
            addNewUserButon,
          ],
        ),
      ),
    );
  }

  Widget get addNewUserButon => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: () => NavController.toSettingsAddUser(),
          child: const Text("Add New User"),
        ),
      );

  Future<void> onDeleteUserPressed({
    required BuildContext context,
    required int index,
  }) async {
    DialogUtils.confirmDialog(
        context: context,
        title: 'Warning! ',
        description: 'Are you sure this user record will be deleted?',
        positiveText: 'Delete',
        negativeText: 'Cancel',
        positiveCallback: () {
          deleteUserCallback(context: context, index: index);
        },
        negativeCallback: () {
          DialogUtils.snackbar(
            context: context,
            message: "Canceled",
            type: SnackbarType.info,
          );
        });
  }

  Future<void> deleteUserCallback({
    required BuildContext context,
    required int index,
  }) async {
    final AppController app = Get.find();
    final result = await db.deleteUser(app.appUserList[index]);

    if (context.mounted) {
      if (result > 0) {
        DialogUtils.snackbar(
          context: context,
          message: "The record has been deleted successfully",
          type: SnackbarType.success,
        );
      } else {
        DialogUtils.snackbar(
          action: SnackBarAction(
            label: "Retry",
            onPressed: () async {
              await db.deleteUser(app.appUserList[index]);
            },
          ),
          context: context,
          message: "There was a problem registering the user.",
          type: SnackbarType.error,
        );
      }
    }
  }
}

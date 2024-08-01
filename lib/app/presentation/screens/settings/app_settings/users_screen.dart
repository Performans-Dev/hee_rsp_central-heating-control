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
  const SettingsUserListScreen({super.key});

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
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(app.userList[index].username.getInitials()),
                    ),
                    title: Text(app.userList[index].username),
                    subtitle: app.userList[index].isAdmin
                        ? const Text('Admin')
                        : const Text('User'),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Change Name"),
                                Icon(Icons.drive_file_rename_outline),
                              ],
                            ),
                            onTap: () async {
                              final result = await OnScreenKeyboard.show(
                                context: context,
                                label: 'Name, Surname',
                                initialValue: app.userList[index].username,
                                type: OSKInputType.name,
                              );
                              if (result != null) {
                                var u = app.userList[index];
                                u.username = result;
                                await DbProvider.db.updateUser(u);
                                app.populateUserList();
                                DialogUtils.snackbar(
                                    type: SnackbarType.success,
                                    context: context,
                                    message: 'Username updated');
                              }
                            },
                          ),
                          PopupMenuItem(
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Change Password"),
                                Icon(Icons.key),
                              ],
                            ),
                            onTap: () async {
                              final result = await OnScreenKeyboard.show(
                                context: context,
                                label: 'Password',
                                initialValue: app.userList[index].pin,
                                type: OSKInputType.number,
                                maxLength: 6,
                                minLength: 6,
                              );
                              if (result != null) {
                                var u = app.userList[index];
                                u.pin = result;
                                await DbProvider.db.updateUser(u);
                                app.populateUserList();
                                DialogUtils.snackbar(
                                    type: SnackbarType.success,
                                    context: context,
                                    message: 'Password updated');
                              }
                              //
                            },
                          ),
                          PopupMenuItem(
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Icon((app.userList[index].isAdmin)
                    //         ? Icons.key
                    //         : Icons.key_off),
                    //     const SizedBox(width: 12),
                    //     IconButton(
                    //       onPressed: () {
                    //         Get.toNamed(
                    //           Routes.settingsUserEdit,
                    //           arguments: [
                    //             app.userList[index],
                    //           ],
                    //         );
                    //       },
                    //       icon: const Icon(Icons.edit),
                    //     ),
                    //     IconButton(
                    //       onPressed: () => onDeleteUserPressed(
                    //         context: context,
                    //         index: index,
                    //       ),
                    //       icon: const Icon(Icons.delete),
                    //     ),
                    //   ],
                    // ),
                  ),
                ),
                itemCount: app.userList.length,
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
    var result = await DbProvider.db.deleteUser(app.userList[index]);

    app.populateUserList();
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
              await DbProvider.db.deleteUser(app.userList[index]);
              app.populateUserList();
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

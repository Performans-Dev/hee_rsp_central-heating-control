import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/content.dart';

import 'package:central_heating_control/app/presentation/screens/home/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

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
            Container(
              width: double.infinity,
              // color: Theme.of(context).focusColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(20),
              child: Text(
                'User Management/ Users',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon((app.userList[index].isAdmin)
                            ? Icons.key
                            : Icons.key_off),
                        const SizedBox(width: 12),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(Routes.settingsUserEdit);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            DialogUtils.confirmDialog(
                              context: context,
                              title: 'Warning! ',
                              description:
                                  'Are you sure this user record will be deleted?',
                              positiveText: 'Delete',
                              negativeText: 'Cancel',
                              onPositive: () async {
                                var result = await DbProvider.db
                                    .deleteUser(app.userList[index]);

                                app.populateUserList();
                                if (result > 0) {
                                  DialogUtils.snackbar(
                                      context: context,
                                      message:
                                          "The record has been deleted successfully",
                                      type: SnackbarType.success);
                                } else {
                                  DialogUtils.snackbar(
                                      action: SnackBarAction(
                                        label: "Retry",
                                        onPressed: () async {
                                          await DbProvider.db
                                              .deleteUser(app.userList[index]);

                                          app.populateUserList();
                                        },
                                      ),
                                      context: context,
                                      message:
                                          "There was a problem registering the user.",
                                      type: SnackbarType.error);
                                }
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
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
            onPressed: () {
              NavController.toSettingsAddUser();
            },
            child: const Text("Add New User")),
      );
}

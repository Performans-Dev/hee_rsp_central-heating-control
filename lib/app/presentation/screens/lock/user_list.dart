import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final AppController app = Get.find();

  int tapCount = 0;

  bool showDeveloper = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
              constraints: const BoxConstraints.expand(),
            ),
          ),
          Center(
            child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surface,
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: InkWell(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  tapCount++;
                                  if (tapCount >= 5) {
                                    showDeveloper = true;
                                    tapCount = 0;
                                  }
                                });
                              }
                            },
                            child: Text(
                              "Select user to unlock",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemBuilder: (context, index) {
                          final user = app.appUserList[index];
                          if (user.username.toLowerCase() == 'developer' &&
                              !showDeveloper) {
                            return const SizedBox();
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(user.username.getInitials()),
                            ),
                            title: Text(
                              user.username,
                            ),
                            onTap: () async {
                              var result = await NavController.toPin(
                                  context: context, username: user.username);
                              await Future.delayed(
                                  const Duration(milliseconds: 200));
                              final loginResult = await app.loginUser(
                                  username: user.username, pin: result ?? "");

                              if (loginResult) {
                                NavController.toHome();
                              } else {
                                if (context.mounted) {
                                  DialogUtils.snackbar(
                                    context: context,
                                    message: "Hatalı pin kodu",
                                    type: SnackbarType.error,
                                  );
                                }
                              }
                            },
                          );
                        },
                        itemCount: app.appUserList.length,
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}



































/*            */
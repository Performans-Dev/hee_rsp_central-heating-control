import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupAdminUserScreen extends StatefulWidget {
  const SetupAdminUserScreen({super.key});

  @override
  State<SetupAdminUserScreen> createState() => _SetupAdminUserScreenState();
}

class _SetupAdminUserScreenState extends State<SetupAdminUserScreen> {
  late final TextEditingController nameController;
  late final TextEditingController pinController;

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
      builder: (app) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 480, maxHeight: 300),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an Admin User'.tr,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Divider(),
                        TextInputWidget(
                          labelText: "Name Surname",
                          controller: nameController,
                        ),
                        const SizedBox(height: 12),
                        TextInputWidget(
                          labelText: "PIN",
                          controller: pinController,
                          obscureText: true,
                          obscuringCharacter: '*',
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty) {
                              logger.d('name required');
                              return;
                            }

                            if (pinController.text.length != 6) {
                              logger.d("invalid pin");
                              return;
                            }

                            AppUser appUser = AppUser(
                              id: -1,
                              username: nameController.text,
                              pin: pinController.text,
                              isAdmin: true,
                            );

                            final result = await DbProvider.db.addUser(appUser);
                            if (result <= 0) {
                              logger.d('add user error');
                              return;
                            }
                            await app.populateUserList();
                            await app.checkFlags();
                            final loginResult = await app.loginUser(
                              username: appUser.username,
                              pin: appUser.pin,
                            );
                            if (loginResult) {
                              NavController.toHome();
                            } else {
                              //TODO: raise alert
                              logger.d('some error');
                            }
                          },
                          child: const Text('Create User'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const StackTopLeftWidget(child: LogoWidget(size: 180)),
              const StackTopRightWidget(child: Text('Initial Setup 5 / 5')),
              StackBottomRightWidget(
                child: ElevatedButton.icon(
                  onPressed: app.hasAdminUser
                      ? () {
                          NavController.toHome();
                        }
                      : null,
                  label: const Text('FINISH'),
                  icon: const Icon(Icons.arrow_right_alt),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

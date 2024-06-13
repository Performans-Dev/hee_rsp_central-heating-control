import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/components/form_item.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SetupAdminUserScreen extends StatefulWidget {
  const SetupAdminUserScreen({super.key});

  @override
  State<SetupAdminUserScreen> createState() => _SetupAdminUserScreenState();
}

class _SetupAdminUserScreenState extends State<SetupAdminUserScreen> {
  late final TextEditingController nameController;
  late final TextEditingController pinController;
  String theMessage = '';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    pinController = TextEditingController();
    initMessage();
  }

  @override
  void dispose() {
    nameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  initMessage() async {
    var m = await DbProvider.db.getDbPath();
    setState(() {
      theMessage = m ?? '';
    });
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
                  child: PiScrollView(
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
                        // TextInputWidget(
                        //   labelText: "Name Surname",
                        //   controller: nameController,

                        // ),
                        FormItemComponent(
                          label: 'Name Surname',
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: UiDimens.formBorder,
                            ),
                            onTap: () async {
                              final result = OnScreenKeyboard.show(
                                context: context,
                                label: 'Name Surname',
                                initialValue: nameController.text,
                              );
                              setState(() {
                                nameController.text = result as String? ?? '';
                              });
                            },
                          ),
                        ),
                        TextInputWidget(
                          labelText: "PIN",
                          controller: pinController,
                          obscureText: true,
                          obscuringCharacter: '*',
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (nameController.text.isEmpty) {
                              DialogUtils.snackbar(
                                  context: context,
                                  message: 'Name cannot be empty');
                              return;
                            }

                            if (pinController.text.length != 6) {
                              DialogUtils.snackbar(
                                  context: context,
                                  message: 'Pin must be 6 digits');
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
                              if (context.mounted) {
                                DialogUtils.snackbar(
                                    context: context,
                                    message: 'User already exists');
                              }
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
                              if (context.mounted) {
                                DialogUtils.snackbar(
                                    context: context, message: 'Login failed');
                              }
                            }
                          },
                          child: const Text('Create User'),
                        ),
                        Text('dbMessage: $theMessage'),
                      ],
                    ),
                  ),
                ),
              ),
              const StackTopLeftWidget(child: LogoWidget(size: 180)),
              const StackTopRightWidget(child: Text('Initial Setup 5 / 5')),
              StackBottomRightWidget(
                child: ElevatedButton.icon(
                  onPressed:
                      // app.hasAdminUser
                      //     ?
                      () async {
                    await app.createAdmin();
                    NavController.toHome();
                  }
                  // : null
                  ,
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

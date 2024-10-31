import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/signin_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceSignInScreen extends StatefulWidget {
  const SetupSequenceSignInScreen({super.key});

  @override
  State<SetupSequenceSignInScreen> createState() =>
      _SetupSequenceSignInScreenState();
}

class _SetupSequenceSignInScreenState extends State<SetupSequenceSignInScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: 'ilker@okutman.com');
    passwordController = TextEditingController(text: '123456');
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return GetBuilder<AppController>(
          builder: (app) {
            return SetupLayout(
                title: 'Sign in'.tr,
                nextLabel: busy ? 'Signing in'.tr : 'Sign in'.tr,
                nextCallback: busy
                    ? null
                    : () async {
                        setState(() => busy = true);
                        final response = await app.accountSignin(
                          email: usernameController.text,
                          password: passwordController.text,
                        );
                        setState(() => busy = false);
                        if (!response.success || response.data == null) {
                          if (context.mounted) {
                            DialogUtils.snackbar(
                              context: context,
                              message: 'Incorrect credentials'.tr,
                              type: SnackbarType.error,
                            );
                          }
                        } else {
                          sc.refreshSetupSequenceList();
                          NavController.toHome();
                        }
                      },
                child: SignInWidget(
                  usernameController: usernameController,
                  passwordController: passwordController,
                  onForgotPassword: () {},
                  onCreateAccount: () {},
                ));
          },
        );
      },
    );
  }
}

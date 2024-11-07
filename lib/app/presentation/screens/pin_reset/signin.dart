import 'dart:io';

import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/signin_request.dart';
import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/body.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/footer_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/signin_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinResetSigninScreen extends StatefulWidget {
  const PinResetSigninScreen({super.key});

  @override
  State<PinResetSigninScreen> createState() => _PinResetSigninScreenState();
}

class _PinResetSigninScreenState extends State<PinResetSigninScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late String username;
  late SigninRequest request;
  bool isBusy = false;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: 'ilker@okutman.com');
    passwordController = TextEditingController(text: '123456');

    username = Get.parameters['username'] ?? '';
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PinResetBodyWidget(
      footer: PinResetFooterWidget(
        nextLabel: isBusy ? "Signing in".tr : "Sign in".tr,
        prevLabel: "Cancel".tr,
        nextAction: isBusy
            ? null
            : () async {
                Get.offAllNamed(Routes.pinResetEntry,
                    parameters: {'username': username});
                return;
                request = SigninRequest(
                  email: usernameController.text,
                  password: passwordController.text,
                );
                setState(() {
                  isBusy = true;
                });
                if (request.email.isNotEmpty && request.password.isNotEmpty) {
                  final result =
                      await AppProvider.accountSignin(request: request);
                  setState(() {
                    isBusy = false;
                  });
                  if (result.success) {
                    Get.offAllNamed(Routes.pinResetEntry,
                        parameters: {'username': username});
                  } else {
                    if (result.statusCode != HttpStatus.ok) {
                      if (context.mounted) {
                        DialogUtils.alertDialog(
                          context: context,
                          title: "Error".tr,
                          description:
                              "Server error. Please try again later.".tr,
                          positiveText: "Ok".tr,
                        );
                      }
                    } else {
                      // TODO: handle other errors
                    }
                  }
                } else {
                  setState(() {
                    isBusy = false;
                  });
                  //TODO: show error
                }
              },
        prevAction: () {
          Get.back();

          NavController.toPin(
            context: context,
            username: username,
          );
        },
      ),
      child: SignInWidget(
        hasCreateButton: false,
        usernameController: usernameController,
        passwordController: passwordController,
        onForgotPassword: () {},
        onCreateAccount: () {},
      ),
    );
  }
}

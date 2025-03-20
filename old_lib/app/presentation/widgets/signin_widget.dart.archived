import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInWidget extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final VoidCallback onForgotPassword;
  final VoidCallback onCreateAccount;
  final bool hasCreateButton;

  const SignInWidget({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.onForgotPassword,
    required this.onCreateAccount,
    this.hasCreateButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            height: 300,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign in with your Heethings account'.tr,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                TextInputWidget(
                  controller: usernameController,
                  labelText: "Email".tr,
                ),
                TextInputWidget(
                  controller: passwordController,
                  labelText: "Password".tr,
                  obscureText: true,
                  obscuringCharacter: '*',
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: hasCreateButton
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: onForgotPassword,
                      child: Text('Forgot Password'.tr),
                    ),
                    hasCreateButton
                        ? TextButton(
                            onPressed: onCreateAccount,
                            child: Text('Create an Account'.tr),
                          )
                        : Container(),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

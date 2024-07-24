import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
import 'package:central_heating_control/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;

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
    return GetBuilder<AppController>(builder: (app) {
      return SetupScaffold(
        label: 'Signin'.tr,
        previousCallback: () {
          Get.toNamed(Routes.setupDateFormat);
        },
        nextCallback: () async {
          final acc = await app.signin(
            email: usernameController.text,
            password: passwordController.text,
          );
          if (acc == null) {
            if (context.mounted) {
              DialogUtils.snackbar(
                context: context,
                message: 'Wrong credentials',
                type: SnackbarType.error,
              );
            }
            logger.d('EEEEEEE');
          } else {
            NavController.toHome();
          }
        },
        nextLabel: "Giriş Yap".tr,
        progressValue: 5 / 9,
        child: Column(
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
                      labelText: "Email",
                      radius: 0,
                    ),
                    TextInputWidget(
                      controller: passwordController,
                      labelText: "Password",
                      radius: 0,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

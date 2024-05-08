import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
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
      return Scaffold(
        body: Stack(
          children: [
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
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final acc = await app.signin(
                              email: usernameController.text,
                              password: passwordController.text,
                            );
                            if (acc == null) {
                              //raise error
                              logger.d('EEEEEEE');
                            } else {
                              NavController.toHome();
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ],
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
            const StackTopLeftWidget(child: LogoWidget(size: 180)),
            const StackTopRightWidget(child: Text('Initial Setup 3 / 4')),
            StackBottomLeftWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Terms of Use'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

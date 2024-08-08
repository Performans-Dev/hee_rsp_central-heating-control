/* import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinRecoveryLogin extends StatefulWidget {
  const PinRecoveryLogin({super.key});

  @override
  State<PinRecoveryLogin> createState() => _PinRecoveryLoginState();
}

class _PinRecoveryLoginState extends State<PinRecoveryLogin> {
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
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
                    'Pininizi sıfırlamak için Heetings hesabınız ile giriş yapın'
                        .tr,
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
                        onPressed: () {
                          DialogUtils.snackbar(
                              context: context,
                              message:
                                  "heetings.com sitesinden şifrenizi sıfırlayabilirsiniz");
                        },
                        child: const Text('Forgot Password'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 60),
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () async {
                final AppController app = Get.find();
                final response = await app.accountSignin(
                  email: usernameController.text,
                  password: passwordController.text,
                );

                if (!response.success || response.data == null) {
                  if (context.mounted) {
                    DialogUtils.snackbar(
                      context: context,
                      message: 'Wrong credentials',
                      type: SnackbarType.error,
                    );
                  }
                } else {
                  Get.offAndToNamed(Routes.pinRecovery);
                }
              },
              child: Text("Giriş Yap"),
            ),
          )
        ],
      ),
    );
  }
}
 */
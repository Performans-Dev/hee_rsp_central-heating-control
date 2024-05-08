import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinScreen extends StatelessWidget {
  const PinScreen({super.key});

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
                  child: ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      leading: CircleAvatar(
                        child: Text(app.userList[index].username.getInitials()),
                      ),
                      title: Text(app.userList[index].username),
                      onTap: () async {
                        final pin = await DialogUtils.pinDialog(
                          context: context,
                          username: app.userList[index].username,
                        );
                        if (pin != null && pin.length == 6) {
                          final loginResult = await app.loginUser(
                              username: app.userList[index].username, pin: pin);
                          if (loginResult) {
                            NavController.toHome();
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Incorrect PIN code.'),
                              duration: Duration(seconds: 2),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        } else {
                          const snackBar = SnackBar(
                            content: Text(
                                'PIN code required, Tap your "Name" and enter your PIN code.'),
                            duration: Duration(seconds: 2),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                    ),
                    itemCount: app.userList.length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

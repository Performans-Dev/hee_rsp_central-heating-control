import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/datetime_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ScreenSaverScreen extends StatefulWidget {
  const ScreenSaverScreen({super.key});

  @override
  State<ScreenSaverScreen> createState() => _ScreenSaverScreenState();
}

class _ScreenSaverScreenState extends State<ScreenSaverScreen> {
  bool showUserList = false;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        body: Stack(
          children: [
            Image.network(
              'https://c4.wallpaperflare.com/wallpaper/849/720/847/two-white-5-petaled-flowers-wallpaper-preview.jpg',
              fit: BoxFit.cover,
              width: Get.width,
              height: Get.height,
            ),
            InkWell(
              onTap: () => setState(() {
                showUserList = !showUserList;
              }),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Container(
                  constraints: BoxConstraints.expand(),
                ),
              ),
            ),
            Center(
              child: DateTextWidget(large: true),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: AnimatedContainer(
                width: 300,
                height: showUserList ? (64 * app.userList.length) + 32 : 0,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(20)),
                  color: Theme.of(context).focusColor.withOpacity(0.3),
                ),
                padding: EdgeInsets.all(16),
                duration: Duration(milliseconds: 300),
                child: showUserList
                    ? ListView.builder(
                        shrinkWrap: false,
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            child: Text(
                                app.userList[index].username.getInitials()),
                          ),
                          title: Text(app.userList[index].username),
                          onTap: () async {
                            final pin = await DialogUtils.pinDialog(
                              context: context,
                              username: app.userList[index].username,
                            );
                            if (pin != null && pin.length == 6) {
                              final loginResult = await app.loginUser(
                                  username: app.userList[index].username,
                                  pin: pin);
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
                      )
                    : null,
              ),
            ),
          ],
        ),
      );
    });
  }
}

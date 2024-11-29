import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/body.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/footer_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinResetEntryScreen extends StatefulWidget {
  const PinResetEntryScreen({super.key});

  @override
  State<PinResetEntryScreen> createState() => _PinResetEntryScreenState();
}

class _PinResetEntryScreenState extends State<PinResetEntryScreen> {
  final digits = [
    '',
    '',
    '',
    '',
    '',
    '',
  ];
  String newPin = "";
  late String username;
  bool isBusy = false;
  @override
  void initState() {
    super.initState();

    username = Get.parameters['username'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return PinResetBodyWidget(
      footer: PinResetFooterWidget(
        nextLabel: isBusy ? 'Saving'.tr : 'Save'.tr,
        nextAction: isBusy
            ? null
            : () async {
                if (newPin.isNotEmpty) {
                  setState(() {
                    isBusy = true;
                  });
                  AppUser? appUser = await DbProvider.db.getUserByName(
                    username: username,
                  );
                  if (appUser != null) {
                    appUser.pin = newPin;
                    final result = await DbProvider.db.updateUser(appUser);
                    setState(() {
                      isBusy = false;
                    });
                    if (result > 0) {
                      final AppController app = Get.find();
                      await app.loadAppUserList();
                      Get.offAllNamed(
                        Routes.pinResetResult,
                        parameters: {'username': username, 'newPin': newPin},
                      );
                    } else {}
                  } else {
                    setState(() {
                      isBusy = false;
                    });
                  }
                } else {}
              },
        prevAction: () {
          Get.back();

          NavController.toPin(context: context, username: username);
        },
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter Your New Pin'),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () async {
                final result = await NavController.toPin(
                    context: context, username: username, isNewPin: true);
                if (result != null) {
                  setState(() {
                    newPin = result;
                    digits.assignAll(newPin.split(""));
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final item in digits)
                    Container(
                      width: 35,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(8),
                      child: Center(
                        child: Text(
                          item.isNotEmpty ? '*' : '',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/pin.dart';
import 'package:central_heating_control/app/presentation/widgets/keypad.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({
    super.key,
    required this.username,
    this.isNewUser = false,
    this.isNewPin = false,
  });

  final String username;
  final bool isNewUser;
  final bool isNewPin;

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  late PinController pinController;

  @override
  void initState() {
    super.initState();
    pinController = Get.put(PinController(), permanent: false);
    pinController.resetPin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .errorContainer
                    .withOpacity(0.3),
                constraints: const BoxConstraints.expand(),
              ),
            ),
            GetBuilder<PinController>(
              builder: (pc) {
                return Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Theme.of(context).canvasColor,
                          constraints: const BoxConstraints(maxWidth: 480),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      margin: const EdgeInsets.only(top: 16),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: widget.username,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500),
                                            ),
                                            TextSpan(
                                              text: widget.isNewUser
                                                  ? 'Pin kodu giriniz'
                                                  : ' için ${widget.isNewPin ? "yeni bir" : ""} PIN kodu girişi yapın '
                                                      .tr,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color
                                                          ?.withOpacity(0.8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => Get.back(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (final item in pc.digits)
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 1; i < 4; i++)
                                    KeypadWidget(
                                      value: '$i',
                                      callback: () => pc.onDigitTapped('$i'),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 4; i < 7; i++)
                                    KeypadWidget(
                                      value: '$i',
                                      callback: () => pc.onDigitTapped('$i'),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 7; i < 10; i++)
                                    KeypadWidget(
                                      value: '$i',
                                      callback: () => pc.onDigitTapped('$i'),
                                    ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  KeypadWidget(
                                    value: 'x',
                                    callback: () => pc.onDigitTapped('x'),
                                  ),
                                  KeypadWidget(
                                    value: '0',
                                    callback: () => pc.onDigitTapped('0'),
                                  ),
                                  KeypadWidget(
                                    value: '>',
                                    callback: pc.pin.length == 6
                                        ? () async {
                                            Get.back(
                                                result: pc.pin,
                                                closeOverlays: true);
                                          }
                                        : null,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (!widget.isNewPin)
                                TextButton(
                                  onPressed: () async {
                                    await Box.setString(
                                      key: Keys.forgottenPin,
                                      value: widget.username,
                                    );

                                    Future.delayed(
                                      Duration.zero,
                                      () {
                                        Get.offAndToNamed(
                                          Routes.pinResetInfo,
                                          parameters: {
                                            'username': widget.username
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Forgot PIN code'.tr),
                                )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
































/*         final pin = await DialogUtils.pinDialog(
                      context: context,
                      username: app.appUserList[index].username,
                    );
                    if (pin != null && pin.length == 6) {
                      final loginResult = await app.loginUser(
                          username: app.appUserList[index].username, pin: pin);
                      if (loginResult) {
                        NavController.toHome();
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Incorrect PIN code.'),
                          duration: Duration(seconds: 2),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    } else {
                      const snackBar = SnackBar(
                        content: Text(
                            'PIN code required, Tap your "Name" and enter your PIN code.'),
                        duration: Duration(seconds: 2),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } */
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/pin.dart';
import 'package:central_heating_control/app/presentation/widgets/keypad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  static confirmDialog({
    required BuildContext context,
    required String title,
    required String? description,
    required String? positiveText,
    required String? negativeText,
    GestureTapCallback? positiveCallback,
    GestureTapCallback? negativeCallback,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: description != null ? Text(description) : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Get.back();
                if (negativeCallback != null) {
                  negativeCallback();
                }
              },
              child: Text(negativeText ?? "No"),
            ),
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Get.back();
                if (positiveCallback != null) {
                  positiveCallback();
                }
              },
              child: Text(positiveText ?? "Yes"),
            ),
          ],
        );
      },
    );
  }

  static alertDialog({
    required BuildContext context,
    required String title,
    required String? description,
    required String? positiveText,
    GestureTapCallback? positiveCallback,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: description != null ? Text(description) : null,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Get.back();
                if (positiveCallback != null) {
                  positiveCallback();
                }
              },
              child: Text(positiveText ?? "Yes"),
            ),
          ],
        );
      },
    );
  }

  static void snackbar({
    required BuildContext context,
    required String message,
    SnackbarType type = SnackbarType.info,
    SnackBarAction? action,
  }) {
    Color? backgroundColor;
    bool? showCloseIcon;
    int seconds = 2;
    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        break;
      case SnackbarType.info:
        backgroundColor = null;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        showCloseIcon = true;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        showCloseIcon = true;
        break;
    }
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
      backgroundColor: backgroundColor,
      action: action,
      showCloseIcon: showCloseIcon,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  progressDialog() {}

  static Future<String?> pinDialog({
    required BuildContext context,
    required String username,
  }) async {
    final PinController pinController = Get.put(PinController());
    pinController.resetPin();
    final result = await showDialog(
      context: context,
      builder: (ctx) {
        return GetBuilder<PinController>(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                          text: username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        TextSpan(
                                          text: ' için PIN kodu girişi yapın ',
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
                                        Get.back(result: pc.pin);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                              onPressed: () {
                                Box.setString(
                                    key: Keys.forgottenPin, value: username);
                                Get.toNamed(Routes.pinReset);
                              },
                              child: Text("Pin kodumu unuttum"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    return result;
  }
}

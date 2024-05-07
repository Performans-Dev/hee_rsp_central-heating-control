import 'package:central_heating_control/app/data/services/pin.dart';
import 'package:central_heating_control/app/presentation/widgets/keypad.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogUtils {
  confirmDialog() {}

  alertDialog() {}

  snackbar() {}

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
                padding: const EdgeInsets.symmetric(vertical: 30),
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
                                  margin: const EdgeInsets.only(top: 20),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              'Kullanıcı için PIN kodu girişi yapın ',
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
                                        TextSpan(
                                          text: username,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w500),
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
                          const SizedBox(height: 12),
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
                          const SizedBox(height: 20),
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

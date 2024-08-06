import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/pin.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class PinRecoveryScreen extends StatefulWidget {
  const PinRecoveryScreen({super.key});

  @override
  State<PinRecoveryScreen> createState() => _PinRecoveryScreenState();
}

class _PinRecoveryScreenState extends State<PinRecoveryScreen> {
  final TextEditingController pinController = TextEditingController();

  final AppController appController = Get.find();
  late String username;
  @override
  void initState() {
    super.initState();
    username = Box.getString(key: Keys.forgottenPin);
  }

  @override
  Widget build(BuildContext context) {
    if (!appController.hasAdminUser) {
      Future.delayed(Duration.zero, (() => Get.toNamed(Routes.signin)));
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Yeni pin kodunuzu giriniz"),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final result = await OnScreenKeyboard.show(
                    context: context,
                    maxLength: 6,
                    minLength: 6,
                    label: "Pin",
                    type: OSKInputType.number,
                  );
                  savePin(result);
                },
                child: const Text("Pin Belirlemek için tıklayın"))
          ],
        ),
      ),
    );
  }

  Future<void> savePin(String newPin) async {
    try {
      final PinController pinController = Get.find();
      final result = await pinController.savePin(newPin, username);
      if (result > 0) {
        AppController appController = Get.find();
        appController.deleteToken();
        Box.setString(key: Keys.forgottenPin, value: "");
        if (mounted) {
          DialogUtils.alertDialog(
            context: context,
            title: "Yeni pin belirlendi",
            description:
                "Belirttiğiniz pin kodu kaydedilmiştir. Artık $username için bu pin kodunu kullanabilirsiniz",
            positiveText: "Tamam",
            positiveCallback: () => Get.back(),
          );
        }
      } else {
        if (mounted) {
          DialogUtils.snackbar(
              context: context,
              message: "Error saving pin",
              type: SnackbarType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        DialogUtils.snackbar(
            context: context,
            message: "Unexpected error occured",
            type: SnackbarType.error);
      }
    }
  }
}

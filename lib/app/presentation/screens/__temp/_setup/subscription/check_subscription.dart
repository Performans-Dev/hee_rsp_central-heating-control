/* import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/models/activation_result.dart';
import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/_setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckSubscriptionScreen extends StatefulWidget {
  const CheckSubscriptionScreen({super.key});

  @override
  State<CheckSubscriptionScreen> createState() =>
      _CheckSubscriptionScreenState();
}

class _CheckSubscriptionScreenState extends State<CheckSubscriptionScreen> {
  final AppController appController = Get.find();

  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    checkSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return SetupScaffold(
        label: "Subscription".tr,
        progressValue: 6 / 9,
        previousCallback: () {
          Buzz.feedback();
          Get.toNamed(Routes.signin);
        },
        nextCallback: () {
          Buzz.feedback();
          NavController.toHome();
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              'Check Subscription'.tr,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Center(
                child: isBusy
                    ? const CircularProgressIndicator()
                    : app.deviceInfo == null
                        ? const Text('Error')
                        : const Text('Please wait'),
              ),
            )
          ],
        ),
      );
    });
  }

  Future<void> checkSubscription() async {
    setState(() {
      isBusy = true;
    });
    late ActivationResult activationResult;
    try {
      activationResult =
          ActivationResult.fromJson(Box.getString(key: Keys.activationResult));
    } on Exception catch (_) {
      activationResult = ActivationResult(
        id: '',
        createdAt: '',
        chcDeviceId: '',
        userId: '',
        status: 0,
        activationTime: '',
      );
    }

    await appController.requestSubscription(activationId: activationResult.id);
    setState(() {
      isBusy = false;
    });

    if (Box.getBool(key: Keys.didCheckedSubscription)) {
      NavController.toHome();
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        checkSubscription();
      });
    }
  }
}
 */
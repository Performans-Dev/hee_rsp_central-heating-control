import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final AppController appController = Get.find();

  bool isBusy = false;
  @override
  void initState() {
    super.initState();
    performActivation();
  }

  @override
  Widget build(BuildContext context) {
    return SetupScaffold(
      progressValue: 8 / 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Activating'.tr,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          Center(
            child: isBusy
                ? const CircularProgressIndicator()
                : appController.chcDeviceId == null
                    ? const Text('Error')
                    : const Text('Please wait'),
          )
        ],
      ),
    );
  }

  Future<void> performActivation() async {
    setState(() {
      isBusy = true;
    });
    await appController.activateChcDevice();
    setState(() {
      isBusy = false;
    });

    if (Box.getBool(key: Keys.didActivated)) {
      NavController.toHome();
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        performActivation();
      });
    }
  }
}

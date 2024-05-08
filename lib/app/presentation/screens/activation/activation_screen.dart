import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
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
    triggerActivate();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        body: Stack(
          children: [
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
                      'Activate '.tr,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    Expanded(
                      child: Center(
                        child: isBusy
                            ? const CircularProgressIndicator()
                            : app.activationId == null
                                ? const Text('error')
                                : const Text('Please wait'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const StackTopLeftWidget(child: LogoWidget(size: 180)),
            const StackTopRightWidget(child: Text('Initial Setup 4 / 4')),
            StackBottomLeftWidget(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Terms of Use'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Privacy Policy'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> triggerActivate() async {
    setState(() {
      isBusy = true;
    });
    final activationId = await appController.checkActivation();
    if (activationId != null) {
      setState(() {
        isBusy = false;
      });
      NavController.toHome();
    } else {
      final activationResult = await appController.activateChcDevice();
      setState(() {
        isBusy = false;
      });
      if (activationResult != null) {
        NavController.toHome();
      }
    }
  }
}

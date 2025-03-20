import 'package:central_heating_control/app/data/providers/app_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';

class SetupSequenceSubscriptionResultScreen extends StatefulWidget {
  const SetupSequenceSubscriptionResultScreen({super.key});

  @override
  State<SetupSequenceSubscriptionResultScreen> createState() =>
      _SetupSequenceSubscriptionResultScreenState();
}

class _SetupSequenceSubscriptionResultScreenState
    extends State<SetupSequenceSubscriptionResultScreen> {
  final AppController appController = Get.find();
  final SetupController setupController = Get.find();
  bool error = false;
  bool initTaskIsRunning = false;

  @override
  void initState() {
    super.initState();
    runInitTask();
  }

  @override
  Widget build(BuildContext context) {
    return SetupLayout(
      title: 'Subscription Status'.tr,
      isExpanded: true,
      child: Center(
        child: error
            ? Center(
                child: ElevatedButton(
                  onPressed: runInitTask,
                  child: const Text(
                    'Retry',
                  ),
                ),
              )
            : LoadingIndicatorWidget(
                text: 'Requesting Subscription Status...'.tr),
      ),
    );
  }

  Future<void> runInitTask() async {
    if (initTaskIsRunning) {
      return;
    }
    setState(() {
      error = false;
      initTaskIsRunning = true;
    });

    final response = await AppProvider.requestSubscription(
      activationId: Guid.newGuid.toString(),
    );

    if (mounted) {
      setState(() {
        initTaskIsRunning = false;
      });
    }
    if (response.success) {
      final AppController app = Get.find();
      app.setHeethingsAccount(app.heethingsAccount?.copyWith(
        subscriptionResult: 0,
        subscriptionExpireDate:
            DateTime.now().add(const Duration(days: 90)).toIso8601String(),
      ));
      setupController.refreshSetupSequenceList();
      NavController.toHome();
    } else {
      if (mounted) {
        setState(() {
          error = true;
        });
      }
    }
  }
}

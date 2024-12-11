// ignore_for_file: avoid_print

import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  @override
  void initState() {
    super.initState();
    print("SETUP SCREEN INIT");
    navigateToNextSequence();
  }

  void navigateToNextSequence() {
    final sc = Get.find<SetupController>();
    final currentSequence =
        sc.setupSequenceList.firstWhereOrNull((e) => !e.isCompleted);

    print("Current Sequence: ${currentSequence?.route}");

    Future.delayed(
      Duration.zero,
      () {
        if (currentSequence == null) {
          print('SETUP COMPLETED');
          Get.offAndToNamed(
              Routes.home); //TODO: replace withsetup success screen
        } else {
          Get.offAndToNamed(currentSequence.route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(
      builder: (sc) {
        return SetupLayout(
          title: 'Initial Setup'.tr,
          isExpanded: true,
          child: Center(
            child: LoadingIndicatorWidget(
              text: 'Please wait while initializing.'.tr,
            ),
          ),
        );
      },
    );
  }
}

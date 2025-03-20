import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/body.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinResetInfoScreen extends StatefulWidget {
  const PinResetInfoScreen({super.key});

  @override
  State<PinResetInfoScreen> createState() => _PinResetInfoScreenState();
}

class _PinResetInfoScreenState extends State<PinResetInfoScreen> {
  late String username;

  @override
  void initState() {
    super.initState();

    username = Get.parameters['username'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return PinResetBodyWidget(
      footer: PinResetFooterWidget(
        nextAction: () {
          Get.offAllNamed(
            Routes.pinResetSignin,
            parameters: {'username': username},
          );
        },
        prevAction: () {
          Get.back();

          NavController.toPin(context: context, username: username);
        },
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi pharetra eros eleifend congue convallis. Donec ligula risus, maximus vitae ex at, posuere congue nibh.'),
          Text(
              "Suspendisse aliquet velit vitae odio vestibulum luctus. Nunc eget dapibus quam. Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
        ],
      ),
    );
  }
}

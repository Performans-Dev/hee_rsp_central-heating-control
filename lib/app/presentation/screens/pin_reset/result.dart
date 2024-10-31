import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/body.dart';
import 'package:central_heating_control/app/presentation/screens/pin_reset/footer_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinResetResultScreen extends StatefulWidget {
  const PinResetResultScreen({super.key});

  @override
  State<PinResetResultScreen> createState() => _PinResetResultScreenState();
}

class _PinResetResultScreenState extends State<PinResetResultScreen> {
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
          NavController.lock(context);
        },
        nextLabel: "Okay",
        hasCancelButton: false,
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('PIN SAVED'),
            Padding(
              padding: EdgeInsets.all(20),
              child: Icon(
                Icons.check_circle,
                size: 80,
              ),
            ),
            Text("Use your new pin"),
          ],
        ),
      ),
    );
  }
}

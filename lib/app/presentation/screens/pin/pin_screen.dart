import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  late String username;

  @override
  void initState() {
    super.initState();
    username = Get.parameters['username'] ?? '';
    if (username.isEmpty) {
      Future.delayed(
        Duration.zero,
        () {
          Get.offAndToNamed(Routes.lockScreen);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Pin Screen'),
      ),
    );
  }
}

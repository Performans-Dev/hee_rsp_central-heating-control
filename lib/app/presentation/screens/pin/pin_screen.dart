import 'package:central_heating_control/app/data/services/nav.dart';
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
      NavController.lock();
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

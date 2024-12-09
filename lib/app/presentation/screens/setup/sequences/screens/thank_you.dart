import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSuccessScreen extends StatelessWidget {
  const SetupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Thank you! Setup is now complete.'.tr),
            ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.home);
                },
                child: Text('Continue'.tr))
          ],
        ),
      ),
    );
  }
}

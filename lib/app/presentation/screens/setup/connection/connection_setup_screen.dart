import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/screens/setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupConnectionScreen extends StatefulWidget {
  const SetupConnectionScreen({super.key});

  @override
  State<SetupConnectionScreen> createState() => _SetupConnectionScreenState();
}

class _SetupConnectionScreenState extends State<SetupConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return SetupScaffold(
          label: 'Connection'.tr,
          previousCallback: () {
            Get.toNamed(Routes.setupDateFormat);
          },
          nextCallback: () async {
            //save dateformat
            Get.toNamed(Routes.home);
          },
          progressValue: 4 / 9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                'Connect your Central Heating Control'.tr,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              app.didConnected
                  ? Text('Connected')
                  : Text(
                      'Not connected //TODO: ask for wifi credentials, add save button, add retry connection button'),
            ],
          ),
        );
      },
    );
  }
}

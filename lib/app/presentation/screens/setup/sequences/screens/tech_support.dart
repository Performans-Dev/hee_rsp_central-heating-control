import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/core/utils/dialogs.dart';
import 'package:central_heating_control/app/data/models/app_user.dart';
import 'package:central_heating_control/app/data/providers/db.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class SetupSequenceTechSupportScreen extends StatefulWidget {
  const SetupSequenceTechSupportScreen({super.key});

  @override
  State<SetupSequenceTechSupportScreen> createState() =>
      _SetupSequenceTechSupportScreenState();
}

class _SetupSequenceTechSupportScreenState
    extends State<SetupSequenceTechSupportScreen> {
  late TextEditingController usernameController;
  late TextEditingController pinController;
DbProvider db=DbProvider.db;
  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(
      text: 'Technical Service'.tr,
    )..addListener(() {
        setState(() {});
      });
    pinController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    usernameController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SetupController>(builder: (sc) {
      return GetBuilder<AppController>(builder: (app) {
        return SetupLayout(
          title: 'Tech Support User'.tr,
          subtitle: 'Please create a user for Tech Support'.tr,
          nextLabel: 'Save'.tr,
          nextCallback: usernameController.text.isEmpty ||
                  pinController.text.isEmpty
              ? null
              : () async {
                  AppUser user = AppUser(
                    id: -1,
                    username: usernameController.text,
                    pin: pinController.text,
                    level: AppUserLevel.techSupport,
                  );
                  final result = await db.addUser( user);
                  if (result>0) {
                    await app.loadAppUserList();
                    await Box.setBool(
                      key: Keys.didTechSupportUserCreated,
                      value: true,
                    );
                    sc.refreshSetupSequenceList();
                    NavController.toHome();
                  } else {
                    if (context.mounted) {
                      DialogUtils.snackbar(
                        context: context,
                        message: result.toString(),
                        type: SnackbarType.error,
                      );
                    }
                  }
                },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              TextInputWidget(
                labelText: 'Full Name'.tr,
                controller: usernameController,
                type: OSKInputType.name,
                minLength: 3,
                maxLenght: 28,
              ),
              const SizedBox(height: 8),
              TextInputWidget(
                isPin: true,
                labelText: 'PIN Code'.tr,
                controller: pinController,
                type: OSKInputType.number,
                obscureText: true,
                obscuringCharacter: '*',
                minLength: 6,
                maxLenght: 6,
              ),
              const SizedBox(height: 8),
              Text(
                  'This user can access to all sections including advanced settings'
                      .tr),
            ],
          ),
        );
      });
    });
  }
}

import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupLanguageScreen extends StatefulWidget {
  const SetupLanguageScreen({super.key});

  @override
  State<SetupLanguageScreen> createState() => _SetupLanguageScreenState();
}

class _SetupLanguageScreenState extends State<SetupLanguageScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (app) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 480, maxHeight: 300),
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Choose your language'.tr,
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const Divider(),
                        for (int i = 0; i < app.languages.length; i++)
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            leading: Icon(
                              i == selectedIndex
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                            ),
                            title: Text(app.languages[i].name),
                            trailing: Text(
                                '${app.languages[i].languageCode}-${app.languages[i].countryCode}'),
                            selected: selectedIndex == i,
                            selectedTileColor: Theme.of(context).highlightColor,
                            onTap: () {
                              setState(() {
                                selectedIndex = i;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const StackTopLeftWidget(child: LogoWidget(size: 180)),
              const StackTopRightWidget(child: Text('Initial Setup 1 / 4')),
              StackBottomRightWidget(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await app.onLanguageSelected(selectedIndex);

                    NavController.toHome();
                  },
                  label: const Text('NEXT'),
                  icon: const Icon(Icons.arrow_right_alt),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

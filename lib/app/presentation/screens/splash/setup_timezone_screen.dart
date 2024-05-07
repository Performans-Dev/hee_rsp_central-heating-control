import 'package:central_heating_control/app/data/routes/routes.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/presentation/widgets/logo.dart';
import 'package:central_heating_control/app/presentation/widgets/stacks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupTimezoneScreen extends StatefulWidget {
  const SetupTimezoneScreen({super.key});

  @override
  State<SetupTimezoneScreen> createState() => _SetupTimezoneScreenState();
}

class _SetupTimezoneScreenState extends State<SetupTimezoneScreen> {
  final AppController appController = Get.find();
  late final ScrollController scrollController;
  int selectedIndex = 0;
  final NavController nav = Get.find();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    selectedIndex =
        appController.timezones.map((e) => e.name).toList().indexOf('Istanbul');

    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        selectedIndex * 64,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 480),
                height: 300,
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose your Timezone'.tr,
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemBuilder: (context, i) => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Text(app.timezones[i].name),
                          subtitle: Text(app.timezones[i].zone),
                          trailing: Text(app.timezones[i].gmt
                              .replaceAll('(', '')
                              .replaceAll(')', '')),
                          leading: Icon(selectedIndex == i
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off),
                          selected: selectedIndex == i,
                          selectedTileColor: Theme.of(context).highlightColor,
                          onTap: () {
                            setState(() {
                              selectedIndex = i;
                            });
                          },
                        ),
                        itemCount: app.timezones.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const StackTopLeftWidget(child: LogoWidget(size: 180)),
            const StackTopRightWidget(child: Text('Initial Setup 2 / 4')),
            StackBottomRightWidget(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await app.onTimezoneSelected(selectedIndex);

                  nav.toHome();
                },
                label: const Text('NEXT'),
                icon: const Icon(Icons.keyboard_arrow_right),
              ),
            ),
            StackBottomLeftWidget(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.offAllNamed(Routes.setupLanguage);
                },
                icon: const Icon(Icons.keyboard_arrow_left),
                label: const Text('PREVIOUS'),
              ),
            ),
          ],
        ),
      );
    });
  }
}

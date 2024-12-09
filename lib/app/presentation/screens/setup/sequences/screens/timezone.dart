import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/setup/sequences/layout/setup_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceTimezoneScreen extends StatefulWidget {
  const SetupSequenceTimezoneScreen({super.key});

  @override
  State<SetupSequenceTimezoneScreen> createState() =>
      _SetupSequenceTimezoneScreenState();
}

class _SetupSequenceTimezoneScreenState
    extends State<SetupSequenceTimezoneScreen> {
  final AppController appController = Get.find();
  late final ScrollController scrollController;
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    selectedIndex = StaticProvider.getTimezoneList
        .map((e) => e["name"])
        .toList()
        .indexOf('Istanbul');

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
    return GetBuilder<SetupController>(builder: (sc) {
      return GetBuilder<AppController>(builder: (app) {
        return SetupLayout(
          title: 'Timezone'.tr,
          nextCallback: () async {
            Buzz.feedback();
            app.setPreferencesDefinition(app.preferencesDefinition.copyWith(
              timezone: StaticProvider.getTimezoneList[selectedIndex]['name'],
            ));

            sc.refreshSetupSequenceList();
            NavController.toHome();
          },
          isExpanded: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: Theme.of(context).canvasColor,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  margin: const EdgeInsets.only(top: 30, bottom: 10),
                  child: Text(
                    'Confirm your timezone'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 80),
                child: Divider(
                  height: 2,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 80),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(StaticProvider.getTimezoneList[i]['name']),
                      subtitle: Text(StaticProvider.getTimezoneList[i]['zone']),
                      trailing: Text(StaticProvider.getTimezoneList[i]['gmt']
                          .replaceAll('(', '')
                          .replaceAll(')', '')),
                      leading: Icon(selectedIndex == i
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off),
                      selected: selectedIndex == i,
                      selectedTileColor: Theme.of(context).highlightColor,
                      onTap: () {
                        Buzz.feedback();
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                    ),
                  ),
                  itemCount: StaticProvider.getTimezoneList.length,
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

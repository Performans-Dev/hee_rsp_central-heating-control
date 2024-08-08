import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/data/services/nav.dart';
import 'package:central_heating_control/app/data/services/setup.dart';
import 'package:central_heating_control/app/presentation/screens/__temp/_setup/setup_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupSequenceTimezoneSection extends StatefulWidget {
  const SetupSequenceTimezoneSection({super.key});

  @override
  State<SetupSequenceTimezoneSection> createState() =>
      _SetupSequenceTimezoneSectionState();
}

class _SetupSequenceTimezoneSectionState
    extends State<SetupSequenceTimezoneSection> {
  final AppController appController = Get.find();
  late final ScrollController scrollController;
  int selectedIndex = 0;
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
    return GetBuilder<SetupController>(builder: (sc) {
      return GetBuilder<AppController>(builder: (app) {
        return SetupScaffold(
          progressValue: sc.progress,
          label: 'Timezone'.tr,
          nextCallback: () async {
            Buzz.feedback();
            await app.onTimezoneSelected(selectedIndex);
            sc.refreshSetupSequenceList();
            NavController.toHome();
          },
          expandChild: true,
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
                        Buzz.feedback();
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                    ),
                  ),
                  itemCount: app.timezones.length,
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}

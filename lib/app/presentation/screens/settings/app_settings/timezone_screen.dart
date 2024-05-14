import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/core/utils/box.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimezoneScreen extends StatefulWidget {
  const TimezoneScreen({super.key});

  @override
  State<TimezoneScreen> createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends State<TimezoneScreen> {
  late TimezoneDefinition _selectedTimezone;
  bool ready = true;
  AppController app = Get.find();
  List<TimezoneDefinition> timezones = [];
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    _selectedTimezone =
        TimezoneDefinition.fromJson(Box.getString(key: Keys.selectedTimezone));
    init();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (ac) {
      return AppScaffold(
        title: 'Timezone',
        selectedIndex: 3,
        body: ready
            ? Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    // color: Theme.of(context).focusColor,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Select Timezone',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: false,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CheckboxListTile(
                          dense: false,
                          selected:
                              _selectedTimezone.name == timezones[index].name,
                          value:
                              _selectedTimezone.name == timezones[index].name,
                          onChanged: (bool? value) async {
                            if (value == true) {
                              setState(() {
                                _selectedTimezone = timezones[index];
                              });
                            }
                          },
                          title: Text(timezones[index].name),
                          subtitle: Text(timezones[index].zone),
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: Text(
                            timezones[index]
                                .gmt
                                .replaceAll('(', '')
                                .replaceAll(')', '')
                                .replaceAll('GMT', ''),
                          ),
                        ),
                      ),
                      itemCount: timezones.length,
                    ),
                  ),
                  actionButton,
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }

  Widget get actionButton => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel")),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () async {
                await Box.setString(
                  key: Keys.selectedTimezone,
                  value: _selectedTimezone.toJson(),
                );
                //TODO: inform OS, update OS timezone
                Get.back();
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );

  Future<void> init() async {
    if (app.timezones.isEmpty) {
      setState(() => ready = false);
      await app.populateTimezones();
      setState(() => ready = true);
    }
    setState(() {
      timezones.assignAll(app.timezones);
    });
    int selectedIndex =
        timezones.map((e) => e.name).toList().indexOf(_selectedTimezone.name);

    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        selectedIndex * 64,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }
}

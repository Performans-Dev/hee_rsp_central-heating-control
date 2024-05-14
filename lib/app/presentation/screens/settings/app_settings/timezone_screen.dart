import 'package:central_heating_control/app/core/localization/localization_service.dart';
import 'package:central_heating_control/app/data/models/timezone_definition.dart';
import 'package:central_heating_control/app/data/services/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimezoneScreen extends StatefulWidget {
  TimezoneScreen({super.key});

  @override
  State<TimezoneScreen> createState() => _TimezoneScreenState();
}

class _TimezoneScreenState extends State<TimezoneScreen> {
  String? _selectedTimezone;

  AppController app = Get.find();
  String timezoneName = '';
  int timezoneOffset = 0;

  @override
  void initState() {
    super.initState();
    timezoneOffset = DateTime.now().toLocal().timeZoneOffset.inHours;
    timezoneName = DateTime.now().toLocal().timeZoneName;
    app.populateTimezones();
    setState(() {
      TimezoneDefinition? t = app.timezones
          .firstWhereOrNull((element) => element.name == timezoneName);
      _selectedTimezone = t?.name;
    });
    //print(timezoneName);
/*     TimezoneDefinition? t = app.timezones
        .firstWhereOrNull((element) => element.name == timezoneName);
    if (t != null) {
      setState(() {
        _selectedTimezone = t.name;
      });
    } */
    // _proceed();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (ac) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Timezone"),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: TextField(
                    focusNode: FocusNode(),
                    decoration: InputDecoration(
                        hintText: "Search...".tr,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onChanged: (value) {},
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CheckboxListTile(
                        dense: true,
                        value: _selectedTimezone == app.timezones[index].name,
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedTimezone =
                                value! ? app.timezones[index].name : null;
                          });
                        },
                        title: Text(app.timezones[index].name),
                        subtitle: Text(app.timezones[index].zone),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    itemCount: app.timezones.length,
                  ),
                ),
              ],
            ),
            actionButton,
          ],
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
                onPressed: _selectedTimezone != null
                    ? () async {
                        await app.onTimezoneSelected(app.timezones.indexWhere(
                            (element) => element.name == _selectedTimezone));

                        print("$_selectedTimezone seçildi. Kaydediliyor...");
                        Get.back();
                      }
                    : null,
                child: const Text("Confirm")),
          ],
        ),
      );
}

import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/widgets/breadcrumb.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class SettingsSensorEditScreen extends StatelessWidget {
  SettingsSensorEditScreen({super.key});

  final String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const BreadcrumbWidget(
            title: 'Settings / Sensor Settings/ Edit Sensor',
          ),
          Expanded(
            child: PiScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextInputWidget(
                    labelText: "Name",
                    keyboardType: TextInputType.name,
                  ),
                  const TextInputWidget(
                    labelText: "MinValue",
                    keyboardType: TextInputType.number,
                  ),
                  const TextInputWidget(
                    labelText: "MaxValue",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButton(
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      isExpanded: true,
                      value: null,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButton(
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      isExpanded: true,
                      value: null,
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                  const SizedBox(
                    height: 200,
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [cancelButton, const SizedBox(width: 12), saveButton],
            ),
          )
        ],
      ),
    );
  }

  Widget get saveButton => ElevatedButton(
        onPressed: () {
          //onSaveButonPressed
        },
        child: const Text("Save"),
      );
  Widget get cancelButton => ElevatedButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel"),
      );
}

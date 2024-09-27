import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:central_heating_control/app/presentation/screens/lock_screen/lock_screen.dart';
import 'package:central_heating_control/app/presentation/widgets/text_input.dart';
import 'package:flutter/material.dart';

class SettingsPreferencesAdvancedHardwareConfigAddNewScreen
    extends StatefulWidget {
  const SettingsPreferencesAdvancedHardwareConfigAddNewScreen({super.key});

  @override
  State<SettingsPreferencesAdvancedHardwareConfigAddNewScreen> createState() =>
      _SettingsPreferencesAdvancedHardwareConfigAddNewScreenState();
}

class _SettingsPreferencesAdvancedHardwareConfigAddNewScreenState
    extends State<SettingsPreferencesAdvancedHardwareConfigAddNewScreen> {
  HardwareExtension? selectedHardwareExtension;
  late TextEditingController serialNumberController;

  @override
  void initState() {
    super.initState();
    serialNumberController = TextEditingController();
  }

  @override
  void dispose() {
    serialNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: 'Add New Hardware',
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          DropdownMenu<HardwareExtension>(
            enableFilter: false,
            enableSearch: false,
            expandedInsets: EdgeInsets.all(1),
            leadingIcon: Icon(Icons.hardware),
            dropdownMenuEntries: StaticProvider.availableHardwareExtensions
                .map((e) => DropdownMenuEntry<HardwareExtension>(
                    label: e.modelName, value: e))
                .toList(),
            label: Text('Available Hardware Profiles'),
            onSelected: (value) {
              setState(() {
                selectedHardwareExtension = value;
              });
            },
          ),
          Divider(),
          Expanded(
            child: selectedHardwareExtension == null
                ? Center(
                    child: Text('Select a hardware profile from list'),
                  )
                : PiScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(
                              '${selectedHardwareExtension?.manufacturer}'),
                          trailing:
                              Text('${selectedHardwareExtension?.modelName}'),
                        ),
                        ListTile(
                          title: Text('Input/Output Count'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('DI: ${selectedHardwareExtension?.diCount}'),
                              VerticalDivider(),
                              Text('DO: ${selectedHardwareExtension?.doCount}'),
                              VerticalDivider(),
                              Text(
                                  'ADC: ${selectedHardwareExtension?.adcCount}'),
                              VerticalDivider(),
                              Text(
                                  'DAC: ${selectedHardwareExtension?.dacCount}'),
                            ],
                          ),
                        ),
                        ListTile(
                          title: Text('Connection'),
                          subtitle: Text(selectedHardwareExtension!
                              .connectionType
                              .map((e) => e.name)
                              .toList()
                              .join(', ')),
                        ),
                        Divider(),
                        TextInputWidget(
                          controller: serialNumberController,
                          labelText: 'Serial number',
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Confirm Adding Hardware'),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

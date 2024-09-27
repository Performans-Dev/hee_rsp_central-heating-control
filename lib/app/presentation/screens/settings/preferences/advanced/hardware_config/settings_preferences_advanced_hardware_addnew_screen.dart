import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/providers/static_provider.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
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
                          title: Text('Manufacturer'),
                          trailing: Text(
                              '${selectedHardwareExtension?.manufacturer}'),
                        ),
                        ListTile(
                          title: Text('Model'),
                          trailing:
                              Text('${selectedHardwareExtension?.modelName}'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ADC: ${selectedHardwareExtension?.adcCount}'),
                            Text('DAC: ${selectedHardwareExtension?.dacCount}'),
                            Text('DI: ${selectedHardwareExtension?.diCount}'),
                            Text('DO: ${selectedHardwareExtension?.doCount}'),
                          ],
                        ),
                        ListTile(
                          title: Text('Connection'),
                          subtitle: Text(selectedHardwareExtension!
                              .connectionType
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

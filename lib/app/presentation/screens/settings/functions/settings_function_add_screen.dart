import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsFunctionAddScreen extends StatelessWidget {
  const SettingsFunctionAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      selectedIndex: 3,
      title: 'Add Function',
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Name'),
                        Text('From'),
                        Text('To'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Zone'),
                        Text('Heater'),
                        Text('Mode'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                    onPressed: () {},
                    label: const Text('Cancel'),
                    icon: const Icon(Icons.cancel)),
                TextButton.icon(
                    onPressed: () {},
                    label: const Text('Save'),
                    icon: const Icon(Icons.save)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

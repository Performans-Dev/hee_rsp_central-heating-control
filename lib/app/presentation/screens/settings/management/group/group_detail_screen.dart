import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/core/utils/dialog_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/app_user/app_user.dart';
import 'package:central_heating_control/app/data/models/group/group.dart';
import 'package:central_heating_control/app/data/models/group/group_inputs.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/textfield.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class ManagementGroupDetailScreen extends StatefulWidget {
  const ManagementGroupDetailScreen({super.key, this.group});
  final GroupDefinition? group;

  @override
  State<ManagementGroupDetailScreen> createState() =>
      _ManagementGroupDetailScreenState();
}

class _ManagementGroupDetailScreenState
    extends State<ManagementGroupDetailScreen> {
  late GroupDefinition group;
  final AppController appController = Get.find();
  // Track the selected tab index
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    group = widget.group ?? GroupDefinition.empty();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      // Properties Tab Widgets
      Widget groupNameWidget = InvertedListTileWidget(
        title: Text('Name your group'.tr),
        subtitle: HtTextField(
          initialValue: group.name,
          onTap: () async {
            final result = await OnScreenKeyboard.show(
              context: context,
              initialValue: group.name,
              hintText: 'Type a name for this group'.tr,
              maxLength: 20,
              minLength: 3,
              type: OSKInputType.name,
              label: 'Group name'.tr,
            );
            if (result != null && mounted) {
              setState(() => group = group.copyWith(name: result));
            }
          },
        ),
      );

      Widget groupColorWidget = InvertedListTileWidget(
        title: Text('Group color'.tr),
        subtitle: InkWell(
          borderRadius: UiDimens.br12,
          onTap: () {
            DialogUtils.itemColorPickerDialog(
                initialValue: group.color,
                onSelected: (value) =>
                    setState(() => group = group.copyWith(color: value)));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: UiDimens.br12,
              color: ColorUtils.itemColorWithValue(context, group.color),
            ),
            child: Center(
              child: Row(
                spacing: 8,
                children: [
                  Text('Change Color'.tr),
                  const Icon(Icons.edit),
                ],
              ),
            ),
          ),
        ),
      );

      Widget groupSchedulePlanWidget = InvertedListTileWidget(
        title: Text('Schedule Plan'.tr),
        subtitle:
            HtTextField(initialValue: (group.schedulePlan ?? 0).toString()),
      );

      Widget groupThermostatWidget = InvertedListTileWidget(
        title: Text('Thermostat'.tr),
        subtitle: Row(
          children: [
            // Checkbox to enable/disable thermostat
            Checkbox(
              tristate: false,
              value: group.thermostatTemperature != 0,
              onChanged: (value) => setState(() => group = group.copyWith(
                    thermostatTemperature: value == true ? 22.0 : 0,
                  )),
            ),
            const Spacer(),
            // Temperature controls
            IconButton(
              onPressed: group.thermostatTemperature == 0
                  ? null
                  : () => setState(() => group = group.copyWith(
                        thermostatTemperature:
                            group.thermostatTemperature - 0.5,
                      )),
              icon: const Icon(Icons.remove),
            ),
            Container(
              alignment: Alignment.center,
              width: 48,
              child: Text(
                group.thermostatTemperature == 0
                    ? '---'
                    : group.thermostatTemperature.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: group.thermostatTemperature == 0
                      ? FontWeight.normal
                      : FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: group.thermostatTemperature == 0
                  ? null
                  : () => setState(() => group = group.copyWith(
                        thermostatTemperature:
                            group.thermostatTemperature + 0.5,
                      )),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      );

      // Combined intervals and cooldown time in a single row with three children
      Widget groupTimingWidget = Row(
        children: [
          Expanded(
            child: InvertedListTileWidget(
              title: Text('Interval On'.tr),
              subtitle:
                  HtTextField(initialValue: (group.intervalOn ?? 0).toString()),
            ),
          ),
          Expanded(
            child: InvertedListTileWidget(
              title: Text('Interval Off'.tr),
              subtitle: HtTextField(
                  initialValue: (group.intervalOff ?? 0).toString()),
            ),
          ),
          Expanded(
            child: InvertedListTileWidget(
              title: Text('Cooldown'.tr),
              subtitle: HtTextField(
                  initialValue: (group.cooldownTime).toString()),
            ),
          ),
        ],
      );

      // Inputs Tab Widgets
      Widget groupInputsWidget = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // Check if this digital input is already in the group's inputs
          final digitalInput = app.digitalInputs[index];
          final existingInputIndex = group.inputs
              .indexWhere((input) => input.digitalInput.id == digitalInput.id);
          final isSelected = existingInputIndex != -1;

          // Get the trigger value if this input is selected
          final triggerValue = isSelected
              ? group.inputs[existingInputIndex].triggerValue
              : false;

          // Find other groups using this input (excluding current group)
          final otherGroups = app.groups
              .where((g) => g.id != group.id &&
                  g.inputs.any((input) => input.digitalInput.id == digitalInput.id))
              .toList();

          // Create usage text
          String usageText = 'Digital input ID: ${digitalInput.id}';
          if (otherGroups.isNotEmpty) {
            usageText += '\nAlso used in: ${otherGroups.map((g) => g.name).join(', ')}';
          }

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: ListTile(
              leading: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  if (value == true) {
                    // Add the digital input to the group
                    setState(() {
                      final newInputs = List<GroupInput>.from(group.inputs);
                      newInputs.add(GroupInput(
                        id: 0, // New item, will be set by the database
                        groupId: group.id,
                        digitalInput: digitalInput,
                        triggerValue: false, // Default trigger value
                      ));
                      group = group.copyWith(inputs: newInputs);
                    });
                  } else {
                    // Remove the digital input from the group
                    setState(() {
                      final newInputs = List<GroupInput>.from(group.inputs)
                        ..removeAt(existingInputIndex);
                      group = group.copyWith(inputs: newInputs);
                    });
                  }
                },
              ),
              title: Text(digitalInput.name),
              subtitle: Text(usageText),
              // Show trigger value switch in the trailing position when input is selected
              trailing: isSelected
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Trigger: '),
                        Switch(
                          value: triggerValue,
                          onChanged: (newValue) {
                            setState(() {
                              final newInputs =
                                  List<GroupInput>.from(group.inputs);
                              newInputs[existingInputIndex] =
                                  newInputs[existingInputIndex].copyWith(
                                triggerValue: newValue,
                              );
                              group = group.copyWith(inputs: newInputs);
                            });
                          },
                        ),
                        Text(triggerValue ? 'ON' : 'OFF'),
                      ],
                    )
                  : null,
            ),
          );
        },
        itemCount: app.digitalInputs.length,
        shrinkWrap: true,
      );

      // Users Tab Widgets
      Widget groupUsersWidget = ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          // Check if this user is already in the group's users
          final appUser = app.appUsers[index];
          final existingUserIndex =
              group.users.indexWhere((user) => user.id == appUser.id);
          final isSelected = existingUserIndex != -1;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: CheckboxListTile(
              value: isSelected,
              onChanged: (value) {
                if (value == true) {
                  // Add the user to the group
                  setState(() {
                    final newUsers = List<AppUser>.from(group.users);
                    newUsers.add(appUser);
                    group = group.copyWith(users: newUsers);
                  });
                } else {
                  // Remove the user from the group
                  setState(() {
                    final newUsers = List<AppUser>.from(group.users)
                      ..removeAt(existingUserIndex);
                    group = group.copyWith(users: newUsers);
                  });
                }
              },
              title: Text(appUser.name),
              subtitle:
                  Text('PIN: ${appUser.pinCode} | Level: ${appUser.level}'),
              controlAffinity: ListTileControlAffinity.leading,
              dense: true,
            ),
          );
        },
        itemCount: app.appUsers.length,
        shrinkWrap: true,
      );

      return AppScaffold(
        hasBackAction: true,
        title: widget.group == null ? 'Add Group'.tr : 'Edit Group'.tr,
        selectedMenuIndex: 3,
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 16,
          children: [
            const SizedBox(width: 96),
            if (widget.group != null)
              FabWidget(
                  onPressed: onDelete,
                  heroTag: 'deleteGroup',
                  icon: Icons.delete,
                  label: 'Delete Group'.tr,
                  color: ColorType.error),
            const Spacer(),
            FabWidget(
              onPressed: onSubmit,
              heroTag: 'saveGroup',
              label: 'Save'.tr,
              icon: Icons.save,
              color: ColorType.secondary,
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(bottom: kToolbarHeight + 10),
          child: Row(
            children: [
              // Navigation Rail
              ValueListenableBuilder<int>(
                valueListenable: selectedIndex,
                builder: (context, index, _) {
                  return NavigationRail(
                    selectedIndex: index,
                    onDestinationSelected: (index) {
                      // Prevent selecting the Sensors tab (index 3)
                      if (index != 3) {
                        selectedIndex.value = index;
                      }
                    },
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings),
                        label: Text('Properties'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.input),
                        label: Text('Inputs'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.people),
                        label: Text('Users'.tr),
                      ),
                      // Disabled Sensors tab for future implementation
                      NavigationRailDestination(
                        icon: Icon(Icons.sensors, color: Colors.grey.withValues(alpha: 0.5)),
                        label: Text('Sensors'.tr, style: TextStyle(color: Colors.grey.withValues(alpha: 0.5))),
                      ),
                    ],
                  );
                },
              ),
              // Content Area
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: selectedIndex,
                  builder: (context, index, _) {
                    return IndexedStack(
                      index: index,
                      children: [
                        // Properties Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Combine name and color into a row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: groupNameWidget,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 2,
                                    child: groupColorWidget,
                                  ),
                                ],
                              ),
                              groupSchedulePlanWidget,
                              groupThermostatWidget,
                              groupTimingWidget,
                            ],
                          ),
                        ),
                        // Inputs Tab
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: groupInputsWidget,
                        ),
                        // Users Tab
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: groupUsersWidget,
                        ),
                        // Sensors Tab (placeholder for future implementation)
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.sensors, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                              const SizedBox(height: 16),
                              Text(
                                'Sensors feature coming soon'.tr,
                                style: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> onSubmit() async {
    if (widget.group == null) {
      await appController.insertGroup(group);
    } else {
      await appController.saveGroup(group);
    }
    Get.back();
  }

  Future<void> onDelete() async {
    DialogUtils.showConfirmDialog(
        context: context,
        title: 'Delete Group'.tr,
        message: 'Are you sure you want to delete this group?'.tr,
        onConfirm: () async {
          await appController.deleteGroup(group.id);
          Get.back();
        });
  }
}

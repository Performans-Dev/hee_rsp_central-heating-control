import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/data/models/device/level_state.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/widgets/common/fab.dart';
import 'package:central_heating_control/app/presentation/widgets/common/ht_dropdown.dart';
import 'package:central_heating_control/app/presentation/widgets/common/icon_picker.dart';
import 'package:central_heating_control/app/presentation/widgets/common/inverted_list_tile_widget.dart';
import 'package:central_heating_control/app/presentation/widgets/common/textfield.dart';
import 'package:central_heating_control/app/presentation/widgets/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_screen_keyboard_tr/on_screen_keyboard_tr.dart';

class ManagementDeviceAddScreen extends StatefulWidget {
  const ManagementDeviceAddScreen({super.key});

  @override
  State<ManagementDeviceAddScreen> createState() =>
      _ManagementDeviceAddScreenState();
}

class _ManagementDeviceAddScreenState extends State<ManagementDeviceAddScreen> {
  final AppController appController = Get.find();
  late PageController _pageController;
  int currentPage = 0;
  late Device device;
  List<LevelStateDefinition> outputLevelStates = [];
  List<LevelStateDefinition> inputLevelStates = [];

  @override
  void initState() {
    super.initState();
    device = Device.empty();
    calculateStates();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          currentPage = _pageController.page!.toInt();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: 'Add Device'.tr,
        hasBackAction: true,
        selectedMenuIndex: 1,
        floatingActionButton: Row(
          spacing: 16,
          children: [
            const SizedBox(width: 96),
            FabWidget(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              label: 'Previous'.tr,
              icon: Icons.arrow_back,
              heroTag: 'add_device_previous',
              enabled: currentPage > 0,
              color: ColorType.secondary,
            ),
            FabWidget(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              label: 'Next'.tr,
              icon: Icons.arrow_forward,
              heroTag: 'add_device_next',
              enabled: currentPage < 3,
              color: ColorType.secondary,
              trailingIcon: true,
            ),
            const Spacer(),
            FabWidget(
              onPressed: onSubmit,
              label: 'Save'.tr,
              icon: Icons.save,
              heroTag: 'save_device',
              enabled: true,
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            buildPage1(context),
            buildPage2(context),
            buildPage3(context),
            buildPage4(context),
          ],
        ),
      );
    });
  }

  Future<void> onSubmit() async {
    List<DeviceState> states = [];
    for (final item in outputLevelStates) {
      states.add(DeviceState(
        id: -1,
        deviceId: -1,
        level: item.state,
        doId: item.portId,
        diId: null,
        value: item.value,
        isFeedback: false,
      ));
    }
    for (final item in inputLevelStates) {
      states.add(DeviceState(
        id: -1,
        deviceId: -1,
        level: item.state,
        doId: null,
        diId: item.portId,
        value: item.value,
        isFeedback: true,
      ));
    }

    setState(() {
      device = device.copyWith(states: states);
    });

    await appController.insertDevice(device);
    Get.back();
  }

  void calculateStates() {
    outputLevelStates = [];
    inputLevelStates = [];
    for (int i = 0; i <= device.levelCount; i++) {
      for (int j = 0; j < device.outputCount; j++) {
        outputLevelStates.add(LevelStateDefinition(
          state: i,
          portId: j,
          value: false,
        ));
      }
      for (int j = 0; j < device.inputCount; j++) {
        inputLevelStates.add(LevelStateDefinition(
          state: i,
          portId: j,
          value: false,
        ));
      }
    }
    setState(() {});
  }

  Widget buildPage1(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: kToolbarHeight),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InvertedListTileWidget(
            title: Text('Name your device'.tr),
            subtitle: HtTextField(
              initialValue: device.name,
              onTap: () async {
                final result = await OnScreenKeyboard.show(
                  context: context,
                  initialValue: device.name,
                  hintText: 'Type a name for this device'.tr,
                  maxLength: 20,
                  minLength: 3,
                  type: OSKInputType.name,
                  label: 'Device name'.tr,
                );
                if (result != null && mounted) {
                  setState(() {
                    device = device.copyWith(name: result);
                  });
                }
              },
            ),
          ),
          GetBuilder<AppController>(builder: (app) {
            return InvertedListTileWidget(
              title: Text('Pick an icon'.tr),
              subtitle: SizedBox(
                width: double.infinity,
                child: app.iconList.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : IconPickerWidget(
                        iconList: app.iconList.map((e) => e.url).toList(),
                        initialValue: device.icon,
                        onSelected: (value) {
                          setState(() {
                            device = device.copyWith(icon: value);
                          });
                        },
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildPage2(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: kToolbarHeight),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: ColorUtils.itemColor(context, ItemColor.lime, alpha: 0.1),
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Level Count'.tr),
                  HtDropdown<int>(
                    initialValue: device.levelCount,
                    options: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
                    onSelected: (value) {
                      setState(() {
                        device = device.copyWith(levelCount: value);
                        List<DeviceLevel> deviceLevels = [];
                        for (int i = 0; i <= device.levelCount; i++) {
                          deviceLevels.add(
                              DeviceLevel(level: i, name: i == 0 ? '0' : '$i'));
                        }
                        device = device.copyWith(levels: deviceLevels);
                      });
                      calculateStates();
                    },
                    labelBuilder: (value) => value.toString(),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 12,
              children: [
                for (int i = 0; i <= device.levelCount; i++)
                  SizedBox(
                    width: 160,
                    child: InvertedListTileWidget(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Level $i'.tr),
                      subtitle: HtTextField(
                        initialValue: device.levels[i].name,
                        onTap: () async {
                          final result = await OnScreenKeyboard.show(
                            context: context,
                            initialValue: device.levels[i].name,
                            hintText: 'Type a name for this level'.tr,
                            maxLength: 20,
                            minLength: 1,
                            type: OSKInputType.name,
                            label: 'Level $i name'.tr,
                          );
                          if (result != null && mounted) {
                            DeviceLevel deviceLevel =
                                device.levels[i].copyWith(name: result);
                            List<DeviceLevel> deviceLevels = device.levels;
                            deviceLevels.replaceRange(i, i + 1, [deviceLevel]);

                            setState(() {
                              device = device.copyWith(
                                levels: deviceLevels,
                              );
                            });
                          }
                        },
                      ),
                    ),
                  )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: ColorUtils.itemColor(context, ItemColor.orange,
                        alpha: 0.1),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Output Relay Count'.tr),
                        HtDropdown<int>(
                          initialValue: device.outputCount,
                          options: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
                          onSelected: (value) {
                            setState(() {
                              device = device
                                  .copyWith(outputCount: value, deviceOutputs: [
                                for (int k = 0; k < value; k++)
                                  DeviceOutput(
                                    id: -1,
                                    deviceId: device.id,
                                    outputId: 0,
                                    priority: 0,
                                    description: '',
                                  ),
                              ]);
                              calculateStates();
                            });
                          },
                          labelBuilder: (value) => value.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: ColorUtils.itemColor(context, ItemColor.purple,
                        alpha: 0.1),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Input Relay Count'.tr),
                        HtDropdown<int>(
                          initialValue: device.inputCount,
                          options: const [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                          onSelected: (value) {
                            setState(() {
                              device = device
                                  .copyWith(inputCount: value, deviceInputs: [
                                for (int k = 0; k < value; k++)
                                  DeviceInput(
                                    id: -1,
                                    deviceId: device.id,
                                    inputId: 0,
                                    priority: 0,
                                    description: '',
                                  ),
                              ]);
                            });
                            calculateStates();
                          },
                          labelBuilder: (value) => value.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget stateView() {
    return GetBuilder<AppController>(builder: (app) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 1,
          children: [
            // title
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: ColorUtils.itemColor(context, ItemColor.lime),
                    child: Center(child: Text('Level'.tr)),
                  ),
                ),
                for (int i = 0; i < device.outputCount; i++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: ColorUtils.itemColor(context, ItemColor.orange),
                      child: Center(
                        child: Text('Output ${i + 1}'.tr),
                      ),
                    ),
                  ),
                for (int i = 0; i < device.inputCount; i++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: ColorUtils.itemColor(context, ItemColor.purple),
                      child: Center(
                        child: Text('Input ${i + 1}'.tr),
                      ),
                    ),
                  ),
              ],
            ),
            // ports
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    height: kToolbarHeight,
                    color: ColorUtils.itemColor(context, ItemColor.lime,
                        alpha: 0.2),
                    child: Center(child: Text('State'.tr)),
                  ),
                ),
                for (int i = 0; i < device.outputCount; i++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: kToolbarHeight,
                      color: ColorUtils.itemColor(context, ItemColor.orange,
                          alpha: 0.2),
                      child: HtDropdown<int>(
                        initialValue: device.deviceOutputs[i].outputId,
                        options: [0, ...app.digitalOutputs.map((e) => e.id)],
                        onSelected: (value) {
                          List<DeviceOutput> outputs = device.deviceOutputs;
                          outputs[i] = outputs[i].copyWith(outputId: value);
                          setState(() {
                            device = device.copyWith(deviceOutputs: outputs);
                          });
                        },
                        labelBuilder: (value) =>
                            value == 0 ? 'None'.tr : 'Output $value',
                        dense: true,
                      ),
                    ),
                  ),
                for (int i = 0; i < device.inputCount; i++)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: kToolbarHeight,
                      color: ColorUtils.itemColor(context, ItemColor.purple,
                          alpha: 0.2),
                      child: HtDropdown<int>(
                        initialValue: device.deviceInputs[i].inputId,
                        options: [0, ...app.digitalInputs.map((e) => e.id)],
                        onSelected: (value) {
                          List<DeviceInput> inputs = device.deviceInputs;
                          inputs[i] = inputs[i].copyWith(inputId: value);
                          setState(() {
                            device = device.copyWith(deviceInputs: inputs);
                          });
                        },
                        labelBuilder: (value) =>
                            value == 0 ? 'None'.tr : 'Input $value',
                        dense: true,
                      ),
                    ),
                  ),
              ],
            ),
            for (int i = 0; i <= device.levelCount; i++)
              // values
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: kToolbarHeight,
                      padding: const EdgeInsets.all(8),
                      color: ColorUtils.itemColor(context, ItemColor.lime,
                          alpha: 0.1),
                      child: Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '$i',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            device.levels[i].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      )),
                    ),
                  ),
                  for (int j = 0; j < device.outputCount; j++)
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: kToolbarHeight,
                        padding: const EdgeInsets.all(8),
                        color: ColorUtils.itemColor(context, ItemColor.orange,
                            alpha: 0.1),
                        child: Checkbox(
                          value: outputLevelStates
                              .firstWhere((e) => e.state == i && e.portId == j)
                              .value,
                          onChanged: (v) {
                            setState(() {
                              outputLevelStates
                                  .firstWhere(
                                      (e) => e.state == i && e.portId == j)
                                  .value = v!;
                            });
                          },
                        ),
                      ),
                    ),
                  for (int j = 0; j < device.inputCount; j++)
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: kToolbarHeight,
                        padding: const EdgeInsets.all(8),
                        color: ColorUtils.itemColor(context, ItemColor.purple,
                            alpha: 0.1),
                        child: Checkbox(
                          value: inputLevelStates
                              .firstWhere((e) => e.state == i && e.portId == j)
                              .value,
                          onChanged: (v) {
                            setState(() {
                              inputLevelStates
                                  .firstWhere(
                                      (e) => e.state == i && e.portId == j)
                                  .value = v!;
                            });
                          },
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget buildPage3(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: kToolbarHeight),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: device.outputCount + device.inputCount > 6
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: (device.outputCount + device.inputCount) * 128,
                child: stateView(),
              ),
            )
          : stateView(),
    );
  }

  Widget buildPage4(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return Container(
        margin: const EdgeInsets.only(bottom: kToolbarHeight),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Zone'.tr),
                  HtDropdown(
                    initialValue: device.groupId,
                    options: app.groups.map((e) => e.id).toList(),
                    onSelected: (value) {
                      setState(() {
                        device = device.copyWith(groupId: value);
                      });
                    },
                    labelBuilder: (value) => value == null
                        ? '-'
                        : app.groups.firstWhere((e) => e.id == value).name,
                  ),
                ],
              ),
              InvertedListTileWidget(
                  title: Text('Device Name'.tr),
                  subtitle: Text(device.name),
                  leading: DeviceIconWidget(icon: device.icon)),
              Row(
                children: [
                  const Expanded(child: Text('State')),
                  ...device.deviceOutputs.map((e) => Expanded(
                      child: Center(child: Text('Out ${e.outputId}')))),
                  ...device.deviceInputs.map((e) =>
                      Expanded(child: Center(child: Text('In ${e.inputId}')))),
                ],
              ),
              for (int i = 0; i <= device.levelCount; i++)
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            '(${device.levels[i].level}) ${device.levels[i].name}')),
                    ...outputLevelStates
                        .where((e) => e.state == device.levels[i].level)
                        .map((e) => Expanded(
                              child: Center(
                                child: e.value
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const Icon(
                                        Icons.remove,
                                        color: Colors.grey,
                                      ),
                              ),
                            )),
                    ...inputLevelStates
                        .where((e) => e.state == device.levels[i].level)
                        .map((e) => Expanded(
                              child: Center(
                                child: e.value
                                    ? const Icon(Icons.check,
                                        color: Colors.green)
                                    : const Icon(
                                        Icons.remove,
                                        color: Colors.grey,
                                      ),
                              ),
                            ))
                  ],
                ),
              const Divider(),
              InvertedListTileWidget(
                title: Text('Levels'.tr),
                subtitle: Row(
                  spacing: 8,
                  children: [
                    ...device.levels.map((e) => Chip(
                          label: Text('${e.level}: ${e.name}'),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

import 'dart:math' as math;
import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_icon.dart';
import 'package:central_heating_control/app/presentation/screens/settings/management/device/widgets/device_state_view.dart';
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
  const ManagementDeviceAddScreen({super.key, this.device});
  final Device? device;

  @override
  State<ManagementDeviceAddScreen> createState() =>
      _ManagementDeviceAddScreenState();
}

class _ManagementDeviceAddScreenState extends State<ManagementDeviceAddScreen> {
  final AppController appController = Get.find();
  late PageController _pageController;
  int currentPage = 0;
  late Device device;
  late int levelCount;
  late int outputCount;
  late int inputCount;

  @override
  void initState() {
    super.initState();
    device = widget.device ?? Device.empty();
    levelCount = math.max(device.levels.length, 2);
    outputCount = device.deviceOutputs.length;
    inputCount = device.deviceInputs.length;
    calculateStates();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          currentPage = _pageController.page!.toInt();
        });
      });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      return AppScaffold(
        title: widget.device == null ? 'Add Device'.tr : 'Edit Device'.tr,
        hasBackAction: true,
        selectedMenuIndex: 3,
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

  // MARK: submit
  Future<void> onSubmit() async {
    if (widget.device == null) {
      await appController.insertDevice(device);
    } else {
      await appController.saveDevice(device);
      Get.back();
    }
    Get.back();
  }

  // MARK: calculate states
  void calculateStates() {
    List<DeviceState> tmpStates = [];
    for (int i = 0; i <= levelCount; i++) {
      for (int j = 0; j < outputCount; j++) {
        tmpStates.add(DeviceState(
          id: -1,
          deviceId: -1,
          level: i,
          doId: 0,
          diId: null,
          indexNumber: j,
          value: false,
          isFeedback: false,
        ));
      }
      for (int j = 0; j < inputCount; j++) {
        tmpStates.add(DeviceState(
          id: -1,
          deviceId: -1,
          level: i,
          doId: null,
          diId: 0,
          indexNumber: j,
          value: false,
          isFeedback: true,
        ));
      }
    }
    setState(() {
      device = device.copyWith(states: tmpStates);
    });
  }

  // MARK: page 1
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

  // MARK: page 2
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
                    initialValue: levelCount,
                    options: const [2, 3, 4, 5, 6, 7, 8, 9, 10],
                    onSelected: (value) {
                      setState(() {
                        // device = device.copyWith(levelCount: value);
                        List<DeviceLevel> deviceLevels = [];

                        for (int i = 0; i <= value - 1; i++) {
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
                for (int i = 0; i <= device.levels.length - 1; i++)
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
                          initialValue: device.deviceOutputs.length,
                          options: const [0, 1, 2, 3, 4, 5, 6, 7, 8],
                          onSelected: (value) {
                            setState(() {
                              outputCount = value;
                              // device = device
                              //     .copyWith(outputCount: value, deviceOutputs: [
                              //   for (int k = 0; k < value; k++)
                              //     DeviceOutput(
                              //       id: -1,
                              //       deviceId: device.id,
                              //       outputId: 0,
                              //       priority: 0,
                              //       description: '',
                              //       indexNumber: k,
                              //     ),
                              // ]);
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
                          initialValue: device.deviceInputs.length,
                          options: const [0, 1, 2, 3, 4, 5, 6, 7, 8],
                          onSelected: (value) {
                            setState(() {
                              inputCount = value;
                              // device = device
                              //     .copyWith(inputCount: value, deviceInputs: [
                              //   for (int k = 0; k < value; k++)
                              //     DeviceInput(
                              //       id: -1,
                              //       deviceId: device.id,
                              //       inputId: 0,
                              //       priority: 0,
                              //       description: '',
                              //       indexNumber: k,
                              //     ),
                              // ]);
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

  // MARK: page 3
  Widget buildPage3(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: kToolbarHeight),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: DeviceStateEditorWidget(
          device: device,
          onDeviceUpdated: (d) {
            setState(() {
              device = d;
            });
          }),
    );
  }

  // MARK: page 4
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
                        : app.groups
                                .firstWhereOrNull((e) => e.id == value)
                                ?.name ??
                            '-',
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
              for (int i = 0; i <= device.levels.length - 1; i++)
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            '(${device.levels[i].level}) ${device.levels[i].name}')),
                  ],
                ),
              const Divider(),
              InvertedListTileWidget(
                title: Text('Test Levels'.tr),
                subtitle: Row(
                  spacing: 8,
                  children: [
                    ...device.levels.map((e) => Chip(
                          label: Text('${e.level}: ${e.name}'),
                        ))
                  ],
                ),
              ),
              DeviceStateViewWidget(device: device),
            ],
          ),
        ),
      );
    });
  }
}

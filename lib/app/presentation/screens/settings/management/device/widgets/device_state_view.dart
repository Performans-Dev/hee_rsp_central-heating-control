// ignore_for_file: avoid_print

import 'package:central_heating_control/app/core/utils/color_utils.dart';
import 'package:central_heating_control/app/data/controllers/app.dart';
import 'package:central_heating_control/app/data/models/device/device.dart';
import 'package:central_heating_control/app/presentation/widgets/common/ht_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceStateEditorWidget extends StatefulWidget {
  const DeviceStateEditorWidget({
    super.key,
    required this.device,
    required this.onDeviceUpdated,
  });
  final Device device;
  final Function(Device) onDeviceUpdated;

  @override
  State<DeviceStateEditorWidget> createState() =>
      _DeviceStateEditorWidgetState();
}

class _DeviceStateEditorWidgetState extends State<DeviceStateEditorWidget> {
  late Device device;

  @override
  void initState() {
    super.initState();
    device = widget.device;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(builder: (app) {
      print('********');
      print(device.toMap().toString());
      print('********');
      for (final item in device.states) {
        print(item.toMap().toString());
      }
      print('********');

      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 1,
          children: [
            Row(
              spacing: 1,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: kToolbarHeight,
                    padding: const EdgeInsets.all(4),
                    color: ColorUtils.itemColor(context, ItemColor.purple),
                    alignment: Alignment.centerLeft,
                    child: Text('InputOutput / Level'.tr),
                  ),
                ),
                for (final l in device.levels)
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: kToolbarHeight,
                      padding: const EdgeInsets.all(4),
                      color: ColorUtils.itemColor(context, ItemColor.purple),
                      child: Center(child: Text('${l.name} (${l.level})')),
                    ),
                  )
              ],
            ),
            for (int j = 0; j < device.deviceOutputs.length; j++)
              Row(
                spacing: 1,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: kToolbarHeight,
                      padding: const EdgeInsets.all(8),
                      color: ColorUtils.itemColor(context, ItemColor.green),
                      child: HtDropdown<int?>(
                        initialValue: device.deviceOutputs[j].outputId,
                        options: app.digitalOutputs.map((e) => e.id).toList(),
                        onSelected: (value) {
                          var port = device.deviceOutputs[j];
                          var ports = device.deviceOutputs;
                          var index = ports.indexOf(port);
                          ports.replaceRange(index, index + 1,
                              [ports[index].copyWith(outputId: value)]);
                          device = device.copyWith(
                            deviceOutputs: ports,
                          );

                          var states = device.states;

                          for (int a = 0; a < states.length; a++) {
                            if (states[a].isFeedback == false &&
                                states[a].indexNumber == port.indexNumber) {
                              states[a] = states[a].copyWith(doId: value);
                            }
                          }

                          device = device.copyWith(states: states);
                          widget.onDeviceUpdated(device);
                          setState(() {});
                        },
                        labelBuilder: (value) {
                          final output = app.digitalOutputs
                              .firstWhereOrNull((e) => e.id == value);
                          return output?.name ?? 'Select Output';
                        },
                        usageInfoBuilder: (value) {
                          if (value == null) return null;

                          // Find devices using this output (excluding current device)
                          final usingDevices = app.devices
                              .where((d) =>
                                  d.id != device.id &&
                                  d.deviceOutputs.any(
                                      (output) => output.outputId == value))
                              .toList();

                          if (usingDevices.isEmpty) return null;
                          return 'Used in: ${usingDevices.map((d) => d.name).join(', ')}';
                        },
                        dense: true,
                      ),
                    ),
                  ),
                  for (final l in device.levels)
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: kToolbarHeight,
                        color: ColorUtils.itemColor(context, ItemColor.green),
                        child: Center(
                          child: Checkbox(
                            value: (device.states
                                    .firstWhereOrNull((e) =>
                                        e.level == l.level &&
                                        e.doId ==
                                            device.deviceOutputs[j].outputId)
                                    ?.value) ??
                                false,
                            onChanged: (value) {
                              var states = device.states;
                              for (int a = 0; a < states.length; a++) {
                                if (!states[a].isFeedback &&
                                    states[a].level == l.level &&
                                    states[a].doId ==
                                        device.deviceOutputs[j].outputId) {
                                  states[a] = states[a].copyWith(value: value!);
                                }
                              }
                              device = device.copyWith(states: states);
                              widget.onDeviceUpdated(device);
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            for (int j = 0; j < device.deviceInputs.length; j++)
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: kToolbarHeight,
                      color: ColorUtils.itemColor(context, ItemColor.orange),
                      child: HtDropdown<int?>(
                        initialValue: device.deviceInputs[j].inputId,
                        options: app.digitalInputs.map((e) => e.id).toList(),
                        onSelected: (value) {
                          var port = device.deviceInputs[j];
                          var ports = device.deviceInputs;
                          var index = ports.indexOf(port);
                          ports.replaceRange(index, index + 1,
                              [ports[index].copyWith(inputId: value)]);
                          device = device.copyWith(
                            deviceInputs: ports,
                          );

                          var states = device.states;

                          for (int a = 0; a < states.length; a++) {
                            if (states[a].isFeedback == true &&
                                states[a].indexNumber == port.indexNumber) {
                              states[a] = states[a].copyWith(diId: value);
                            }
                          }

                          device = device.copyWith(states: states);
                          widget.onDeviceUpdated(device);
                          setState(() {});
                        },
                        labelBuilder: (value) {
                          final input = app.digitalInputs
                              .firstWhereOrNull((e) => e.id == value);
                          return input?.name ?? 'Select Input';
                        },
                        usageInfoBuilder: (value) {
                          if (value == null) return null;

                          // Find devices using this input (excluding current device)
                          final usingDevices = app.devices
                              .where((d) =>
                                  d.id != device.id &&
                                  d.deviceInputs
                                      .any((input) => input.inputId == value))
                              .toList();

                          // Find groups using this input
                          final usingGroups = app.groups
                              .where((g) => g.inputs.any(
                                  (input) => input.digitalInput.id == value))
                              .toList();

                          List<String> usageInfo = [];

                          if (usingDevices.isNotEmpty) {
                            usageInfo.add(
                                'Used in devices: ${usingDevices.map((d) => d.name).join(', ')}');
                          }

                          if (usingGroups.isNotEmpty) {
                            usageInfo.add(
                                'Used in groups: ${usingGroups.map((g) => g.name).join(', ')}');
                          }

                          return usageInfo.isEmpty
                              ? null
                              : usageInfo.join('\n');
                        },
                      ),
                    ),
                  ),
                  for (final l in device.levels)
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: kToolbarHeight,
                        color: ColorUtils.itemColor(context, ItemColor.orange),
                        child: Center(
                          child: Checkbox(
                              value: (device.states
                                      .firstWhereOrNull((e) =>
                                          e.level == l.level &&
                                          e.isFeedback &&
                                          e.diId ==
                                              device.deviceInputs[j].inputId)
                                      ?.value) ??
                                  false,
                              onChanged: (value) {
                                var states = device.states;
                                for (int a = 0; a < states.length; a++) {
                                  if (states[a].isFeedback &&
                                      states[a].level == l.level &&
                                      states[a].diId ==
                                          device.deviceInputs[j].inputId) {
                                    states[a] =
                                        states[a].copyWith(value: value!);
                                  }
                                }
                                device = device.copyWith(states: states);
                                widget.onDeviceUpdated(device);
                                setState(() {});
                              }),
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
}

class DeviceStateViewWidget extends StatelessWidget {
  const DeviceStateViewWidget({super.key, required this.device});
  final Device device;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: kToolbarHeight,
          color: ColorUtils.itemColor(context, ItemColor.purple),
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text('State/Level'),
              ),
              for (final l in device.levels)
                Expanded(
                  flex: 1,
                  child: Text('${l.name} (${l.level})'),
                ),
            ],
          ),
        ),
        for (final outputDevice in device.deviceOutputs)
          Container(
            height: kToolbarHeight,
            color: ColorUtils.itemColor(context, ItemColor.green),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Output ${outputDevice.outputId}'),
                ),
                for (final l in device.levels)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: device.states
                                  .firstWhereOrNull((e) =>
                                      e.doId == outputDevice.outputId &&
                                      e.level == l.level &&
                                      e.isFeedback == false)
                                  ?.value ==
                              true
                          ? const Icon(Icons.check)
                          : const Icon(Icons.remove),
                    ),
                  ),
              ],
            ),
          ),
        for (final inputDevice in device.deviceInputs)
          Container(
            height: kToolbarHeight,
            color: ColorUtils.itemColor(context, ItemColor.orange),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Input ${inputDevice.inputId}'),
                ),
                for (final l in device.levels)
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: device.states
                                  .firstWhereOrNull((e) =>
                                      e.diId == inputDevice.inputId &&
                                      e.level == l.level &&
                                      e.isFeedback == true)
                                  ?.value ==
                              true
                          ? const Icon(Icons.check)
                          : const Icon(Icons.remove),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

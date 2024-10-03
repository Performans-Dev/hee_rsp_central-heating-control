import 'package:central_heating_control/app/core/constants/dimens.dart';
import 'package:central_heating_control/app/core/constants/enums.dart';
import 'package:central_heating_control/app/core/extensions/string_extensions.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/gpio.dart';
import 'package:central_heating_control/app/data/services/state.dart';
import 'package:central_heating_control/app/presentation/components/pi_scroll.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPreferencesAdvancedDiagnosticsScreen extends StatefulWidget {
  const SettingsPreferencesAdvancedDiagnosticsScreen({super.key});

  @override
  State<SettingsPreferencesAdvancedDiagnosticsScreen> createState() =>
      _SettingsPreferencesAdvancedDiagnosticsScreenState();
}

class _SettingsPreferencesAdvancedDiagnosticsScreenState
    extends State<SettingsPreferencesAdvancedDiagnosticsScreen> {
  final GpioController gpioController = Get.find();
  final DataController dataController = Get.find();

  int selectedSerialDevice = 0x01;
  SerialCommand selectedSerialCommand = SerialCommand.test;
  int selectedSerialData1 = 0x00;
  int selectedSerialData2 = 0x00;
  List<int> serialDataPresets = [
    0x00,
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GpioController>(
      builder: (gc) {
        return GetBuilder<StateController>(
          builder: (sc) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Diagnostics'),
                actions: [
                  TextButton(
                      onPressed: () {
                        sc.populateList();
                      },
                      child: const Text('init'))
                ],
              ),
              body: PiScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...sc.stateDeviceIds
                        .map((e) => DiagnosticSectionWidget(hwId: e)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class DiagnosticSectionWidget extends StatelessWidget {
  const DiagnosticSectionWidget({super.key, required this.hwId});
  final int hwId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(builder: (sc) {
      final hardwareTypeList = sc.hardwareTypes(hwId: hwId);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Row(
              children: [
                Text(
                  hardwareName(hwId),
                ),
                Expanded(
                  child: Container(),
                ),
                if (hwId > 0)
                  ElevatedButton(
                    onPressed: () {
                      sc.sendSerialCommand(
                        id: hwId,
                        command: SerialCommand.readNtc,
                      );
                    },
                    child: const Text('Read NTC'),
                  ),
                SizedBox(width: 8),
                if (hwId > 0)
                  ElevatedButton(
                    onPressed: () {
                      sc.sendSerialCommand(
                        id: hwId,
                        command: SerialCommand.readInputs,
                      );
                    },
                    child: const Text('Read All Inputs'),
                  ),
                SizedBox(width: 8),
                if (hwId > 0)
                  ElevatedButton(
                    onPressed: () {
                      sc.sendSerialCommand(
                        id: hwId,
                        command: SerialCommand.readOutputs,
                      );
                    },
                    child: const Text('Read All Outputs'),
                  ),
                SizedBox(width: 8),
                if (hwId > 0)
                  ElevatedButton(
                    onPressed: () {
                      sc.sendSerialCommand(
                        id: hwId,
                        command: SerialCommand.test,
                      );
                    },
                    child: const Text('Test'),
                  ),
                SizedBox(width: 8),
                if (hwId > 0)
                  ElevatedButton(
                    onPressed: () {
                      sc.sendSerialCommand(
                        id: hwId,
                        command: SerialCommand.restartDevice,
                      );
                    },
                    child: const Text('Restart'),
                  ),
                SizedBox(width: 8),
              ],
            ),
          ),
          ...hardwareTypeList.map(
              (e) => DiagnosticHardwareTypeWidget(hardwareType: e, hwId: hwId)),
        ],
      );
    });
  }

  String hardwareName(int id) {
    switch (id) {
      case 0:
        return 'Onboard';
      default:
        return 'Serial Uart #$id';
    }
  }
}

class DiagnosticHardwareTypeWidget extends StatelessWidget {
  const DiagnosticHardwareTypeWidget({
    super.key,
    required this.hardwareType,
    required this.hwId,
  });

  final HardwareType hardwareType;
  final int hwId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(builder: (sc) {
      final pinTypeList = sc.pinTypes(hwId: hwId, hardwareType: hardwareType);
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(hardwareType.name.camelCaseToHumanReadable()),
          hwId > 0
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...pinTypeList.map((e) => DiagnosticPinTypeWidget(
                        pinType: e, hwId: hwId, hardwareType: hardwareType)),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...pinTypeList.map((e) => DiagnosticPinTypeWidget(
                        pinType: e, hwId: hwId, hardwareType: hardwareType)),
                  ],
                ),
        ],
      );
    });
  }
}

class DiagnosticPinTypeWidget extends StatelessWidget {
  const DiagnosticPinTypeWidget({
    super.key,
    required this.pinType,
    required this.hwId,
    required this.hardwareType,
  });

  final PinType pinType;
  final int hwId;
  final HardwareType hardwareType;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(builder: (sc) {
      final list = sc.getStateList(
        hwId: hwId,
        hardwareType: hardwareType,
        pinType: pinType,
      );
      return Expanded(
        flex: list.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pinType.name.camelCaseToHumanReadable()),
            Row(
              children: list
                  .map((e) => DiagnosticStateWidget(
                      stateModel: e, index: list.indexOf(e)))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }
}

class DiagnosticStateWidget extends StatelessWidget {
  const DiagnosticStateWidget({
    super.key,
    required this.stateModel,
    required this.index,
  });
  final StateModel stateModel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StateController>(builder: (sc) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: UiDimens.formRadius,
        ),
        margin: const EdgeInsets.all(2),
        child: InkWell(
          borderRadius: UiDimens.formRadius,
          onTap: stateModel.pinType == PinType.digitalOutput
              ? () {
                  sc.sendSerialCommand(
                    id: stateModel.hwId,
                    command: SerialCommand.setSingleOut,
                    data1: (index + 1),
                    data2: stateModel.pinValue ? 0 : 1,
                  );
                }
              : null,
          child: ClipRRect(
            borderRadius: UiDimens.formRadius,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text((index + 1).toString()),
                  stateModel.pinType == PinType.analogInput
                      ? Text('${stateModel.analogValue}')
                      : Icon(
                          Icons.sunny,
                          color:
                              stateModel.pinValue ? Colors.green : Colors.grey,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

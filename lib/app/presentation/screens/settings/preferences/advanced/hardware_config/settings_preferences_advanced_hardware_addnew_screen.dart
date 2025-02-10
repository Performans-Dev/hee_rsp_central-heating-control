import 'dart:async';

import 'package:central_heating_control/app/data/models/hardware.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/channel_controller.dart';
import 'package:central_heating_control/app/presentation/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum HardwareInstallScreenState {
  idle,
  acquiringNextId,
  awaitingForCheckTrigger,
  checking,
  receivedSuccessResponse,
  receivedFailureResponse,
  timedout,
  awaitingDbOperation,
  completed,
  failed,
}

class SettingsPreferencesAdvancedHardwareConfigAddNewScreen
    extends StatefulWidget {
  const SettingsPreferencesAdvancedHardwareConfigAddNewScreen({super.key});

  @override
  State<SettingsPreferencesAdvancedHardwareConfigAddNewScreen> createState() =>
      _SettingsPreferencesAdvancedHardwareConfigAddNewScreenState();
}

class _SettingsPreferencesAdvancedHardwareConfigAddNewScreenState
    extends State<SettingsPreferencesAdvancedHardwareConfigAddNewScreen> {
  HardwareInstallScreenState screenState = HardwareInstallScreenState.idle;
  final DataController dataController = Get.find();
  // final ChannelController channelController = Get.find();
  late int nextHardwareId;
  late StreamSubscription<SerialQuery> subscription;
  late StreamSubscription<String> logSubscription;
  late Timer timer;
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {});
    // subscription = channelController.serialQueryStreamController.stream
    //     .listen(onSerialQueryDataReceived);
    // logSubscription =
    //     channelController.logMessageController.stream.listen((data) {
    //   setState(() {
    //     messages.insert(0, data);
    //     if (messages.length > 1000) {
    //       messages.removeRange(999, messages.length);
    //     }
    //   });
    // });
    // loadExistingHardwareExtensions();
  }

  @override
  void dispose() {
    timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
    /* return GetBuilder<DataController>(
      builder: (dc) {
        const acquiringNextIdWidget = Center(
          child: CircularProgressIndicator(),
        );

        final awaitingForCheckTriggerWidget = Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Connect your hardware and set its ID to $nextHardwareId. Hit continue when done.'),
            ElevatedButton(
              onPressed: triggerHardwareCheck,
              child: const Text('Continue'),
            ),
            ElevatedButton(
              onPressed: () {
                channelController.queryReboot(nextHardwareId);
              },
              child: const Text('Reboot'),
            ),
            ElevatedButton(
              onPressed: () {
                channelController.queryTest(nextHardwareId);
              },
              child: const Text('Test'),
            ),
          ],
        );

        const checkingWidget = Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Querying hardware...'),
            ],
          ),
        );

        final receivedSuccessResponseWidget = Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Communication successfull with $nextHardwareId. Hit Install Device button to use it.'),
            ElevatedButton(
              onPressed: onInstallDeviceClicked,
              child: const Text('Install Device'),
            ),
          ],
        );

        final receivedFailureResponseWidget = Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Cannot communicate with $nextHardwareId. Try again.'),
            Text(
                'Connect your hardware and set its ID to $nextHardwareId. Hit continue when done.'),
            ElevatedButton(
              onPressed: triggerHardwareCheck,
              child: const Text('Continue'),
            ),
          ],
        );

        final timedOutWidget = Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Cannot communicate with $nextHardwareId within the specific time. Operation timed out.'),
            Text(
                'Connect your hardware and set its ID to $nextHardwareId. Hit continue when done.'),
            ElevatedButton(
              onPressed: triggerHardwareCheck,
              child: const Text('Continue'),
            ),
          ],
        );

        const awaitingDbOperationWidget = Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Installing hardware...'),
            ],
          ),
        );

        final completedWidget = Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
                'Hardware [$nextHardwareId] install is successful. Reboot System to start using it.'),
            ElevatedButton(
              onPressed: onRebootClicked,
              child: const Text('Reboot Now'),
            ),
          ],
        );

        final failedWidget = Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Cannot install $nextHardwareId'),
            ElevatedButton(
              onPressed: tryAgainClicked,
              child: const Text('Try Again'),
            ),
          ],
        );

        Widget pageBody = Container();
        switch (screenState) {
          case HardwareInstallScreenState.acquiringNextId:
            pageBody = acquiringNextIdWidget;
            break;
          case HardwareInstallScreenState.awaitingForCheckTrigger:
            pageBody = awaitingForCheckTriggerWidget;
            break;
          case HardwareInstallScreenState.checking:
            pageBody = checkingWidget;
            break;
          case HardwareInstallScreenState.receivedSuccessResponse:
            pageBody = receivedSuccessResponseWidget;
            break;
          case HardwareInstallScreenState.receivedFailureResponse:
            pageBody = receivedFailureResponseWidget;
            break;
          case HardwareInstallScreenState.timedout:
            pageBody = timedOutWidget;
            break;
          case HardwareInstallScreenState.awaitingDbOperation:
            pageBody = awaitingDbOperationWidget;
            break;
          case HardwareInstallScreenState.completed:
            pageBody = completedWidget;
            break;
          case HardwareInstallScreenState.failed:
            pageBody = failedWidget;
            break;
          default:
            break;
        }

        return AppScaffold(
          selectedIndex: 3,
          title: 'Add New Hardware',
          body: Row(
            children: [
              Expanded(child: pageBody),
              SizedBox(
                width: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.green.withValues(alpha: 0.2),
                      child: Obx(() => Text(
                          channelController.currentSerialMessage == null
                              ? '---'
                              : channelController.currentSerialMessage!
                                  .toLog())),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Text(messages[index]),
                        itemCount: messages.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ); */
  }

  /* Future<void> loadExistingHardwareExtensions() async {
    setState(() => screenState = HardwareInstallScreenState.acquiringNextId);
    await dataController.loadHardwareDevices();
    setState(() => nextHardwareId = 0);

    List<Hardware> tmpList = dataController.hardwareDeviceList;
    tmpList.sort((a, b) => a.deviceId.compareTo(b.deviceId));
    if (tmpList.isNotEmpty) {
      setState(() => nextHardwareId = tmpList.last.deviceId + 1);
    }

    setState(
        () => screenState = HardwareInstallScreenState.awaitingForCheckTrigger);
  }

  Future<void> triggerHardwareCheck() async {
    setState(() => screenState = HardwareInstallScreenState.checking);
    channelController.queryTest(nextHardwareId);
    timer.cancel();
    timer = Timer(const Duration(seconds: 15), () {
      setState(() => screenState = HardwareInstallScreenState.timedout);
      if (nextHardwareId == 0x01) {
        channelController.turnOffSerialLoop();
      }
    });
  }

  void onSerialQueryDataReceived(SerialQuery serialQuery) async {
    setState(() => messages.insert(0, serialQuery.response ?? ''));

    if (serialQuery.deviceId == nextHardwareId) {
      timer.cancel();
      setState(() =>
          screenState = HardwareInstallScreenState.receivedSuccessResponse);
    } else {
      messages.insert(0, 'invalid serial query response received');
    }
  }

  Future<void> onInstallDeviceClicked() async {
    setState(
        () => screenState = HardwareInstallScreenState.awaitingDbOperation);
    // add to db
    // if success
    setState(() => screenState = HardwareInstallScreenState.completed);
    // if fail
    // setState(() => screenState = HardwareInstallScreenState.failed);
  }

  Future<void> onRebootClicked() async {
    //show confirm dialog
  }

  Future<void> tryAgainClicked() async {
    //close 'add' screen, user should try again
    Get.back();
  } */
}

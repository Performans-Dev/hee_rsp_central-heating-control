import 'dart:async';

import 'package:central_heating_control/app/data/models/hardware_extension.dart';
import 'package:central_heating_control/app/data/services/data.dart';
import 'package:central_heating_control/app/data/services/state_controller.dart';
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
  final StateController stateController = Get.find();
  late int nextHardwareId;
  late StreamSubscription<SerialQuery> subscription;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration.zero, () {});
    subscription = stateController.serialQueryStreamController.stream
        .listen(onSerialQueryDataReceived);
    loadExistingHardwareExtensions();
  }

  @override
  void dispose() {
    timer.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DataController>(builder: (dc) {
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
        body: pageBody,
      );
    });
  }

  Future<void> loadExistingHardwareExtensions() async {
    setState(() => screenState = HardwareInstallScreenState.acquiringNextId);
    await dataController.loadHardwareExtensions();
    setState(() => nextHardwareId = 0);

    List<HardwareExtension> tmpList = dataController.hardwareExtensionList;
    tmpList.sort((a, b) => a.deviceId.compareTo(b.deviceId));
    if (tmpList.isNotEmpty) {
      setState(() => nextHardwareId = tmpList.last.deviceId + 1);
    }
    
    setState(
        () => screenState = HardwareInstallScreenState.awaitingForCheckTrigger);
  }

  Future<void> triggerHardwareCheck() async {
    setState(() => screenState = HardwareInstallScreenState.checking);
    stateController.queryTest(nextHardwareId);
    timer.cancel();
    timer = Timer(const Duration(seconds: 5), () {
      setState(() => screenState = HardwareInstallScreenState.timedout);
    });
  }

  void onSerialQueryDataReceived(SerialQuery serialQuery) async {
    if (serialQuery.deviceId == nextHardwareId) {
      timer.cancel();
      setState(() =>
          screenState = HardwareInstallScreenState.receivedSuccessResponse);
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
  }
}

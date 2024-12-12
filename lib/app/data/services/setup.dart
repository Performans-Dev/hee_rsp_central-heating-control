// ignore_for_file: avoid_print

import 'package:central_heating_control/app/data/models/setup_sequence.dart';
import 'package:get/get.dart';

class SetupController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    refreshSetupSequenceList();
  }

  final RxList<SetupSequence> _setupSequenceList = <SetupSequence>[].obs;
  List<SetupSequence> get setupSequenceList => _setupSequenceList;

  void refreshSetupSequenceList() {
    _setupSequenceList.clear();
    _setupSequenceList.addAll([
      SetupSequence.welcome(),
      SetupSequence.language(), //pref
      SetupSequence.timezone(), //pref
      SetupSequence.dateFormat(), //pref
      // SetupSequence.terms(), //account
      // SetupSequence.privacy(), //account
      // SetupSequence.signIn(), //account
      // SetupSequence.subscriptionResult(), //account
      SetupSequence.techSupport(), //flag
      SetupSequence.adminUser(), //flag
      SetupSequence.theme(), //pref
      SetupSequence.thanks(),
    ]);
    update();
    print("SETUP SEQUENCE LIST REFRESHED");
  }

  double get progress =>
      setupSequenceList.where((e) => e.isCompleted).length /
      setupSequenceList.length;
}

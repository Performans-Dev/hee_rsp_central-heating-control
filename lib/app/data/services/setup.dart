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
      SetupSequence.language(),
      SetupSequence.timezone(),
      SetupSequence.dateFormat(),
      SetupSequence.theme(),
      SetupSequence.registerDevice(),
      SetupSequence.signIn(),
      SetupSequence.activation(),
      SetupSequence.subscriptionResult(),
      SetupSequence.techSupport(),
      SetupSequence.adminUser(),
    ]);
    update();
  }
}

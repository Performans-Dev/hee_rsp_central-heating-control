import 'package:central_heating_control/app/data/models/input_outputs/analog_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_input.dart';
import 'package:central_heating_control/app/data/models/input_outputs/digital_output.dart';
import 'package:central_heating_control/app/data/providers/db_provider.dart';
import 'package:get/get.dart';

class IOController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _loadInputOutputs();
  }

  final RxList<AnalogInput> _analogInputs = <AnalogInput>[].obs;
  List<AnalogInput> get analogInputs => _analogInputs;
  final RxList<DigitalInput> _digitalInputs = <DigitalInput>[].obs;
  List<DigitalInput> get digitalInputs => _digitalInputs;
  final RxList<DigitalOutput> _digitalOutputs = <DigitalOutput>[].obs;
  List<DigitalOutput> get digitalOutputs => _digitalOutputs;

  Future<void> _loadInputOutputs() async {
    final analogInputs = await DbProvider.db.getAnalogInputs();
    final digitalInputs = await DbProvider.db.getDigitalInputs();
    final digitalOutputs = await DbProvider.db.getDigitalOutputs();
    _analogInputs.assignAll(analogInputs);
    _digitalInputs.assignAll(digitalInputs);
    _digitalOutputs.assignAll(digitalOutputs);
    update();
  }

  Future<void> saveAnalogInput(AnalogInput analogInput) async {
    final response = await DbProvider.db.saveAnalogInput(analogInput);
    if (response > 0) {
      _loadInputOutputs();
    }
  }

  Future<void> saveDigitalInput(DigitalInput digitalInput) async {
    final response = await DbProvider.db.saveDigitalInput(digitalInput);
    if (response > 0) {
      _loadInputOutputs();
    }
  }

  Future<void> saveDigitalOutput(DigitalOutput digitalOutput) async {
    final response = await DbProvider.db.saveDigitalOutput(digitalOutput);
    if (response > 0) {
      _loadInputOutputs();
    }
  }
}

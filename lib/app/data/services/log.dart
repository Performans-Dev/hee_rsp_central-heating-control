import 'package:central_heating_control/app/data/models/log.dart';
import 'package:get/get.dart';

class LogController extends GetxController {
  final RxList<LogDefinition> _logs = <LogDefinition>[].obs;
  List<LogDefinition> get logs => _logs;

  /// Inserts a [LogDefinition] into the list of logs and triggers an update.
  ///
  /// The [log] parameter is the [LogDefinition] to be inserted.
  ///
  /// This function adds the [log] to the list of logs and triggers an update
  /// by calling the [update] method.
  ///
  /// Returns nothing.
  void insertLog(LogDefinition log) {
    _logs.add(log);
    update();
  }
}

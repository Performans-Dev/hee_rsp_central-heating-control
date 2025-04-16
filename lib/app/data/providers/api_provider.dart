import 'package:central_heating_control/app/data/models/preferences/icon.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  static Future<List<IconDefinition>> fetchIconIndex() async {
    Dio dio = Dio();
    List<IconDefinition> icons = [];
    try {
      final response =
          await dio.get('https://heethings.com/cc/assets/icons/icons.json');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data is List) {
          icons = data.map((e) => IconDefinition.fromMap(e)).toList();
        }
      }
      return icons;
    } catch (e) {
      return icons;
    }
  }
}

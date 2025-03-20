import 'package:central_heating_control/app/core/constants/keys.dart';

class GenericResponse<T> {
  bool success;
  int statusCode;
  T? data;
  String? message;
  String? error;
  GenericResponse({
    this.success = false,
    this.statusCode = 400,
    this.data,
    this.message,
    this.error,
  });

  factory GenericResponse.error({
    String? message,
    int? statusCode,
    String? error,
  }) =>
      GenericResponse(
        message: message,
        statusCode: statusCode ?? 400,
        error: error,
      );

  factory GenericResponse.success(T? data, {int statusCode = 200}) =>
      GenericResponse(
        statusCode: statusCode,
        success: true,
        data: data,
      );

  factory GenericResponse.fromResponse(Map<String, dynamic>? response) =>
      (response == null || response[Keys.success] != true)
          ? GenericResponse.error(error: response.toString())
          : GenericResponse(
              success: response[Keys.success],
              statusCode: response[Keys.statusCode],
              data: response[Keys.data],
              message: response[Keys.message],
            );
}

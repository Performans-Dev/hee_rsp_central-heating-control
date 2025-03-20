import 'dart:io';

import 'package:central_heating_control/app/core/constants/api.dart';
import 'package:central_heating_control/app/core/constants/keys.dart';
import 'package:central_heating_control/app/data/models/generic_response.dart';
import 'package:dio/dio.dart';

class NetworkUtils {
  static String buildUrl(String partUrl) {
    if (partUrl.startsWith(Keys.http)) {
      return partUrl;
    }
    return '${Api.baseUrl}$partUrl';
  }

  static GenericResponse processDioResponse(Response dioResponse) {
    try {
      switch (dioResponse.statusCode) {
        case HttpStatus.ok:
          if (dioResponse.data[Keys.success]) {
            return GenericResponse.success(dioResponse.data[Keys.data]);
          } else {
            return GenericResponse.error();
          }
        case HttpStatus.badRequest:
        case HttpStatus.unauthorized:
        case HttpStatus.forbidden:
        case HttpStatus.methodNotAllowed:
        default:
          return GenericResponse.error(
            statusCode: dioResponse.statusCode,
            error: 'error',
          );
      }
    } on Exception catch (e) {
      return processError({'error': e.toString()});
    }
  }

  static GenericResponse processDioError(DioException exception) {
    return GenericResponse.error(
      statusCode:
          exception.response?.statusCode ?? HttpStatus.internalServerError,
      error: exception.toString(),
    );
  }

  static GenericResponse processError(Map<String, dynamic>? response) {
    return GenericResponse.error(
      statusCode: response?[Keys.statusCode] ?? HttpStatus.internalServerError,
      error: response.toString(),
    );
  }
}

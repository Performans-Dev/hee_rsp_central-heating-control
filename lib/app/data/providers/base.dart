// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:central_heating_control/app/core/utils/buzz.dart';
import 'package:central_heating_control/app/core/utils/network.dart';
import 'package:central_heating_control/app/data/models/generic_response.dart';
import 'package:central_heating_control/main.dart';
import 'package:central_heating_control/secrets.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

class BaseNetworkProvider {
  static Dio _getDio() {
    final Map<String, String> headers = {
      'Access-Control-Allow-Origin': '*',
      'Accept': '*/*',
      'X-Api-Key': 'b75a185c-0cb9-4223-86b9-90a1a85d3b48', //Secrets.apiKey,
    };
    Dio dio = Dio();
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.contentType = 'application/json';
    dio.options.headers.addAll(headers);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    if (!kIsWeb) {
      dio.options.followRedirects = false;
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient dioClient) {
        dioClient.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };
    }
    return dio;
  }

  static Future<GenericResponse> get(String partUrl) async {
    try {
      Dio dio = _getDio();
      String url = NetworkUtils.buildUrl(partUrl);
      logger.d('GET: $url');
      final Response response = await dio.get(url);
      logger.d('Success: $url ${response.statusCode}');
      return NetworkUtils.processDioResponse(response);
    } on DioException catch (error) {
      logger.e('Error:', error: error);
      Buzz.error();
      return NetworkUtils.processDioError(error);
    } catch (exception) {
      logger.e('Error:', error: exception);
      Buzz.error();
      return NetworkUtils.processError({'error': exception.toString()});
    }
  }

  static Future<GenericResponse> post(
    String partUrl, {
    required Map<String, dynamic> data,
  }) async {
    try {
      Dio dio = _getDio();
      String url = NetworkUtils.buildUrl(partUrl);
      logger.d('GET: $url');
      final Response response = await dio.post(url, data: data);
      logger.d('Success: $url ${response.statusCode}');
      return NetworkUtils.processDioResponse(response);
    } on DioException catch (error) {
      logger.e('Error:', error: error);
      Buzz.error();
      return NetworkUtils.processDioError(error);
    } catch (exception) {
      logger.e('Error:', error: exception);
      Buzz.error();
      return NetworkUtils.processError({'error': exception.toString()});
    }
  }
}

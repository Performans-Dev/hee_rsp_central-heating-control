// ignore_for_file: deprecated_member_use

import 'dart:io';

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
      'X-Api-Key': Secrets.apiKey,
    };
    Dio dio = Dio();
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
      return NetworkUtils.processDioError(error);
    } catch (exception) {
      logger.e('Error:', error: exception);
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
      return NetworkUtils.processDioError(error);
    } catch (exception) {
      logger.e('Error:', error: exception);
      return NetworkUtils.processError({'error': exception.toString()});
    }
  }
}

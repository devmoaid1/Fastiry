import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/api/interceptors.dart';
import 'package:efood_multivendor/data/errors/status_code.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../errors/exeptions.dart';

class DioConsumer extends GetxService implements ApiConsumer {
  final dio.Dio client;

  DioConsumer({@required this.client}) {
    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    client.options
      ..baseUrl = AppConstants.BASE_URL
      ..responseType = dio.ResponseType.plain
      ..followRedirects = false
      ..validateStatus = ((status) {
        return status < StatusCode.internalServerError;
      });

    client.interceptors.add(Get.find<AppInterceptors>());

    if (kDebugMode) {
      client.interceptors.add(Get.find<dio.LogInterceptor>());
    }
  }
  @override
  Future delete(String path, {Map<String, dynamic> queryParams}) async {
    try {
      final response = await client.delete(path, queryParameters: queryParams);

      return _handleResponseAsJson(response);
    } on dio.DioError catch (err) {
      _handleDioError(err);
    }
  }

  @override
  Future get(String path, {Map<String, dynamic> queryParams}) async {
    try {
      final response = await client.get(path, queryParameters: queryParams);

      return _handleResponseAsJson(response);
    } on dio.DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(String path,
      {Map<String, dynamic> queryParams, Map<String, dynamic> body}) async {
    try {
      final response =
          await client.post(path, queryParameters: queryParams, data: body);

      return _handleResponseAsJson(response);
    } on dio.DioError catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(String path,
      {Map<String, dynamic> queryParams, Map<String, dynamic> body}) async {
    try {
      final response =
          await client.post(path, queryParameters: queryParams, data: body);

      return _handleResponseAsJson(response);
    } on dio.DioError catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleResponseAsJson(dio.Response<dynamic> response) {
    final responseJson = jsonDecode(response.data.toString());
    return responseJson;
  }

  dynamic _handleDioError(dio.DioError error) {
    switch (error.type) {
      case dio.DioErrorType.connectTimeout:
      case dio.DioErrorType.sendTimeout:
      case dio.DioErrorType.receiveTimeout:
        throw FetchDataException();
      case dio.DioErrorType.response:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw BadRequestException();
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw UnauthorizedException();
          case StatusCode.notFound:
            throw NotFoundException();
          case StatusCode.confilct:
            throw ConflictException();

          case StatusCode.internalServerError:
            throw InternalServerErrorException();
        }
        break;
      case dio.DioErrorType.cancel:
        break;
      case dio.DioErrorType.other:
        throw NoInternetConnectionException();
    }
  }
}

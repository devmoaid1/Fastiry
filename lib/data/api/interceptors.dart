import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';

class AppInterceptors extends GetxService implements dio.Interceptor {
  @override
  void onError(dio.DioError err, dio.ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    return handler.next(err);
  }

  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    final sharedPreferences = Get.find<SharedPreferences>();

    options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.ZONE_ID: jsonEncode([2, 1]),
      AppConstants.LOCALIZATION_KEY:
          sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
              AppConstants.languages[0].languageCode,
      'Authorization':
          'Bearer ${sharedPreferences.getString(AppConstants.TOKEN) ?? ""} '
    };

    debugPrint(
        'REQUEST[${options.method}] => PATH: ${options.path} AND HEADERS : ${options.headers}');
    return handler.next(options);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return handler.next(response);
  }
}

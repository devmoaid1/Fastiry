import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:http_parser/http_parser.dart';

import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:http/http.dart' as Http;

import '../errors/exeptions.dart';
import '../errors/status_code.dart';

class HttpConumer extends GetxService implements ApiConsumer {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String token;
  Map<String, String> _mainHeaders;

  HttpConumer({@required this.appBaseUrl, @required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    debugPrint('Token: $token');
    AddressModel _addressModel;
    try {
      final addressString =
          sharedPreferences.getString(AppConstants.USER_ADDRESS);

      if (addressString != null) {
        _addressModel = AddressModel.fromJson(jsonDecode(addressString));
      }

      updateHeader(
        token,
        _addressModel == null ? null : _addressModel.zoneIds,
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
      );
      print('-------------');
      print(_addressModel.toJson());
    } catch (e) {}
    updateHeader(
      token,
      _addressModel == null ? null : _addressModel.zoneIds,
      sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
    );
  }

  void updateHeader(String token, List<int> zoneIDs, String languageCode) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.ZONE_ID: zoneIDs != null ? jsonEncode(zoneIDs) : null,
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': 'Bearer $token'
    };
  }

  Future get(String path,
      {Map<String, dynamic> queryParams, Map<String, dynamic> headers}) async {
    try {
      debugPrint('====> API Call: $path\nHeader: $_mainHeaders');
      Http.Response _response = await Http.get(
        Uri.parse(appBaseUrl + path),
        // headers: {'Content-Type': 'application/json; charset=utf8'}
        headers: headers ?? _mainHeaders,
      ).whenComplete(
        () => print("completed"),
      );
      return _handleResponse(_response, path);
    } on Response catch (e) {
      _handleHttpError(e);
    }
  }

  Future post(String path,
      {Map<String, dynamic> queryParams,
      Map<String, dynamic> body,
      Map<String, dynamic> headers}) async {
    try {
      debugPrint('====> API Call: $path\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + path),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      );
      return _handleResponse(_response, path);
    } on Response catch (e) {
      _handleHttpError(e);
    }
  }

  Future postMultipartData(
      String uri, Map<String, String> body, List<MultipartBody> multipartBody,
      {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.MultipartRequest _request =
          Http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      _request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
        if (multipart.file != null) {
          if (Foundation.kIsWeb) {
            Uint8List _list = await multipart.file.readAsBytes();
            Http.MultipartFile _part = Http.MultipartFile(
              multipart.key,
              multipart.file.readAsBytes().asStream(),
              _list.length,
              filename: basename(multipart.file.path),
              contentType: MediaType('image', 'jpg'),
            );
            _request.files.add(_part);
          } else {
            File _file = File(multipart.file.path);
            _request.files.add(Http.MultipartFile(
              multipart.key,
              _file.readAsBytes().asStream(),
              _file.lengthSync(),
              filename: _file.path.split('/').last,
            ));
          }
        }
      }
      _request.fields.addAll(body);
      Http.Response _response =
          await Http.Response.fromStream(await _request.send());
      return _handleResponse(_response, uri);
    } on Response catch (e) {
      _handleHttpError(e);
    }
  }

  Future put(String path,
      {Map<String, dynamic> queryParams,
      Map<String, dynamic> body,
      Map<String, dynamic> headers}) async {
    try {
      debugPrint('====> API Call: $path\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.put(
        Uri.parse(appBaseUrl + path),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      );
      return _handleResponse(_response, path);
    } on Response catch (e) {
      _handleHttpError(e);
    }
  }

  Future delete(String path,
      {Map<String, dynamic> queryParams, Map<String, dynamic> headers}) async {
    try {
      debugPrint('====> API Call: $path\nHeader: $_mainHeaders');
      Http.Response _response = await Http.delete(
        Uri.parse(appBaseUrl + path),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return _handleResponse(_response, path);
    } on Response catch (e) {
      _handleHttpError(e);
    }
  }

  dynamic _handleResponse(Http.Response response, String uri) {
    dynamic _body;
    _body = jsonDecode(response.body);
    debugPrint(
        '====> API Response: [${response.statusCode}] $uri\n${_body.body}');
    return _body;
  }
}

dynamic _handleHttpError(Response response) {
  switch (response.statusCode) {
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
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}

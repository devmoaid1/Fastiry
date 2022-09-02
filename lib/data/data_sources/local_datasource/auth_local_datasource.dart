import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_constants.dart';

abstract class AuthLocalDataSource {
  Future<bool> saveUserToken(String token);

  String getUserToken();

  bool isLoggedIn();

  bool clearSharedData();
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({@required this.sharedPreferences});
  @override
  bool clearSharedData() {}

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  @override
  Future<bool> saveUserToken(String token) async {
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  @override
  Future<void> saveUserNumberAndPassword(
      String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(
          AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }
}

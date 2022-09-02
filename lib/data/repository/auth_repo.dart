// ignore_for_file: missing_return

import 'dart:async';

import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/data/model/response/google_response.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/cart_controller.dart';
import '../../controller/wishlist_controller.dart';

class AuthRepo {
  final ApiConsumer apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.apiClient, @required this.sharedPreferences});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookAuth _faceBookAuth = FacebookAuth.i;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.post(AppConstants.REGISTER_URI,
        body: signUpBody.toJson());
  }

  Future<Response> login({String phone, String password}) async {
    return await apiClient.post(AppConstants.LOGIN_URI,
        body: {"phone": phone, "password": password});
  }

  Future<Response> loginWithSocialMedia(String email) async {
    return await apiClient
        .post(AppConstants.SOCIAL_LOGIN_URL, body: {"email": email});
  }

  Future<Response> registerWithSocialMedia(
      SocialLogInBody socialLogInBody) async {
    return await apiClient.post(AppConstants.SOCIAL_REGISTER_URL,
        body: socialLogInBody.toJson());
  }

  Future<GoogleResponse> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await _googleAuth.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCrediential = await _auth.signInWithCredential(credential);

      final response = GoogleResponse(googleAuth.idToken, userCrediential);
      // Once signed in, return the UserCredential
      return response;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e.message.toString();
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      final loginResult = await _faceBookAuth.login();

      final faceBookCredentials =
          FacebookAuthProvider.credential(loginResult.accessToken.token);

      return await _auth.signInWithCredential(faceBookCredentials);
    } on FirebaseAuthException catch (err) {
      print(err.message);
    }
  }

  Future<Response> updateToken() async {
    String _deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    } else {
      _deviceToken = await _saveDeviceToken();
    }
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.post(AppConstants.TOKEN_URI,
        body: {"_method": "put", "cm_firebase_token": _deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = '@';
    if (!GetPlatform.isWeb) {
      try {
        _deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {}
    }
    if (_deviceToken != null) {
      print('--------Device Token---------- ' + _deviceToken);
    }
    return _deviceToken;
  }

  Future<Response> getUserByEmail(String email) async {
    return await apiClient.post('${AppConstants.getUserUri}$email', body: {});
  }

  Future<Response> forgetPassword(String phone) async {
    return await apiClient
        .post(AppConstants.FORGET_PASSWORD_URI, body: {"phone": phone});
  }

  Future<Response> verifyToken(String phone, String token) async {
    return await apiClient.post(AppConstants.VERIFY_TOKEN_URI,
        body: {"phone": phone, "reset_token": token});
  }

  Future<Response> resetPassword(String resetToken, String number,
      String password, String confirmPassword) async {
    return await apiClient.post(
      AppConstants.RESET_PASSWORD_URI,
      body: {
        "_method": "put",
        "reset_token": resetToken,
        "phone": number,
        "password": password,
        "confirm_password": confirmPassword
      },
    );
  }

  // Future<Response> checkEmail(String email) async {
  //   return await apiClient
  //       .post(AppConstants.CHECK_EMAIL_URI, body: {"email": email});
  // }

  // Future<Response> verifyEmail(String email, String token) async {
  //   return await apiClient.post(AppConstants.VERIFY_EMAIL_URI,
  //       body: {"email": email, "token": token});
  // }

  Future<Response> updateZone() async {
    return await apiClient.get(AppConstants.UPDATE_ZONE_URL);
  }

  Future<Response> verifyPhone(String phone, String otp) async {
    return await apiClient.post(AppConstants.VERIFY_PHONE_URI,
        body: {"phone": phone, "otp": otp});
  }

  // for  user token
  Future<bool> saveUserToken(String token) async {
    // apiClient.token = token;
    // apiClient.updateHeader(
    //     token, null, sharedPreferences.getString(AppConstants.LANGUAGE_CODE));
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool checkSocialUser() {
    return sharedPreferences.containsKey(AppConstants.socialUser);
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  Future<bool> isGoogleUser() async {
    return await _googleAuth.isSignedIn();
  }

  bool clearSharedData() {
    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
      apiClient.post(AppConstants.TOKEN_URI,
          body: {"_method": "put", "cm_firebase_token": '@'});
    }
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    // apiClient.token = null;
    // apiClient.updateHeader(null, null, null);
    return true;
  }

  // for  Remember Email
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

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if (isActive) {
      updateToken();
    } else {
      if (!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
        if (isLoggedIn()) {
          FirebaseMessaging.instance.unsubscribeFromTopic(
              'zone_${Get.find<LocationController>().getUserAddress().zoneId}_customer');
        }
      }
    }
    sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }

  Future<void> googleSignOut() async {
    final isGoogleLoggedIn = await _googleAuth.isSignedIn();
    if (isGoogleLoggedIn) {
      await _googleAuth.signOut();
    }
  }

  Future<void> logout() async {
    googleSignOut();
    clearSharedData();
    Get.find<CartController>().clearCartList();
    Get.find<WishListController>().removeWishes();
  }
}

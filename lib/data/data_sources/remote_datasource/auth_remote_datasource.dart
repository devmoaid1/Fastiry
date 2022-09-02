import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/data/model/response/auth/login_model.dart';
import 'package:efood_multivendor/data/model/response/auth/sign_up_model.dart';
import 'package:efood_multivendor/data/model/response/google_response.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<SignUpModel> registerUser(SignUpBody signUpBody);
  Future<LoginModel> loginUser(String phone, String password);
  Future<GoogleResponse> googleSignIn();
  Future<void> googleSignOut();
  Future<bool> isGoogleUser();
  Future<Response> updateToken();
}

class AuthRemoteDataImpl implements AuthRemoteDataSource {
  final ApiConsumer apiClient;

  AuthRemoteDataImpl({@required this.apiClient});
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleAuth = GoogleSignIn();
  @override
  Future<SignUpModel> registerUser(SignUpBody signUpBody) async {
    final response = await apiClient.post(AppConstants.REGISTER_URI,
        body: signUpBody.toJson());

    return SignUpModel.fromJson(response);
  }

  @override
  Future<LoginModel> loginUser(String phone, String password) async {
    final response = await apiClient.post(AppConstants.LOGIN_URI,
        body: {'phone': phone, 'password': password});

    return LoginModel.fromJson(response);
  }

  @override
  Future<GoogleResponse> googleSignIn() async {
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

  @override
  Future<void> googleSignOut() async {
    final isGoogleLoggedIn =
        await _googleAuth.isSignedIn(); // check if user signed
    if (isGoogleLoggedIn) {
      await _googleAuth.signOut(); // sign out if user signed in already
    }
  }

  @override
  Future<bool> isGoogleUser() async {
    return await _googleAuth.isSignedIn();
  }

  @override
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
}

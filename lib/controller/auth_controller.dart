import 'dart:convert';

import '/controller/splash_controller.dart';
import '/data/api/api_checker.dart';
import '/data/model/body/signup_body.dart';
import '/data/model/body/social_customer.dart';
import '/data/model/body/social_log_in_body.dart';
import '/data/model/response/response_model.dart';
import '/data/model/response/userinfo_model.dart';
import '/data/repository/auth_repo.dart';
import '/helper/route_helper.dart';
import '/view/base/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/body/customer.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({@required this.authRepo}) {
    _notification = authRepo.isNotificationActive();
  }

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  bool _isGoogleUser = false;

  bool get isGoogleUser => _isGoogleUser;
  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (!Get.find<SplashController>().configModel.customerVerification) {
        authRepo.saveUserToken(response.body["token"]);
        await authRepo.updateToken();
      }
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone: phone, password: password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (Get.find<SplashController>().configModel.customerVerification &&
          response.body['is_phone_verified'] == 0) {
      } else {
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
      }
      responseModel = ResponseModel(true,
          '${response.body['is_phone_verified']}${response.body['token']}');
    } else {
      responseModel = ResponseModel(false, "phone_or_password_is_invalid".tr);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    _isLoading = true;
    update();
    Response response =
        await authRepo.loginWithSocialMedia(socialLogInBody.email);
    if (response.statusCode == 200) {
      String _token = response.body['token'];
      if (_token != null && _token.isNotEmpty) {
        if (Get.find<SplashController>().configModel.customerVerification &&
            response.body['is_phone_verified'] == 0) {
          Get.toNamed(RouteHelper.getVerificationRoute(
              socialLogInBody.email, _token, RouteHelper.signUp, ''));
        } else {
          authRepo.saveUserToken(response.body['token']);
          await authRepo.updateToken();
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }
      } else {
        Get.toNamed(
            RouteHelper.getForgotPassRoute(true, socialLogInBody, "", null));
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    _isLoading = false;
    update();
  }

  Future<UserInfoModel> getUserByEmail(String email) async {
    UserInfoModel user = UserInfoModel();
    await authRepo.getUserByEmail(email).then((response) {
      if (response.bodyString.startsWith('{"user"')) {
        user = UserInfoModel.fromJson(response.body['user']);
      }
    });

    return user;
  }

  Future<void> facebookSignIn() async {
    try {
      final result = await authRepo.signInWithFacebook();
      print(result.user.email);
    } catch (err) {
      showCustomSnackBar(err);
    }
  }

  Future<void> googleSignIn() async {
    try {
      bool isSocialExist = false;
      final result = await authRepo.signInWithGoogle();
      final token = result.token;
      final user = result.userCredential.user;
      final socialUser = await getUserByEmail(user.email);
      // check is there a existing customer registered

      if (socialUser.email != null) {
        isSocialExist = true;
      }

      if (!isSocialExist) {
        //new user go to phone verification
        handleNewSocialUser(token, user);
      } else {
        //existing user login and go to location page
        handleSocialLogin(socialUser);
      }

      _isLoading = false;
      update();
    } catch (err) {
      _isLoading = false;
      update();
      print(err.toString());
      showCustomSnackBar("something_wrong".tr);
    }
  }

  void handleNewSocialUser(String token, User user) {
    final SocialLogInBody newSocialUser = SocialLogInBody(
        email: user.email,
        medium: 'google',
        phone: user.phoneNumber,
        token: token,
        uniqueId: user.uid);

    Get.toNamed(RouteHelper.getForgotPassRoute(
        true,
        newSocialUser,
        token,
        Customer(
            email: user.email,
            firstName: user.displayName.split(' ')[0],
            lastName: user.displayName.split(' ')[1],
            phone: user.phoneNumber)));
  }

  void handleSocialLogin(UserInfoModel user) {
    login(user.phone.trim(), user.email.trim()).then((status) {
      if (status.isSuccess) {
        String _token = status.message.substring(1, status.message.length);
        if (Get.find<SplashController>().configModel.customerVerification &&
            int.parse(status.message[0]) == 0) {
          List<int> _encoded = utf8.encode(user.email);
          String _data = base64Encode(_encoded);
          Get.toNamed(RouteHelper.getVerificationRoute(
              user.phone, _token, RouteHelper.signUp, _data));
        } else {
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }

  Future<void> handleSocialPhone(
      SocialLogInBody body, Customer user, String token) async {
    final SignUpBody signUpBody = SignUpBody(
        email: body.email,
        fName: user.firstName,
        lName: user.lastName,
        password: body.email,
        phone: body.phone,
        refCode: ''); // create sign up body to register social user

    registration(signUpBody).then((status) {
      final SocialCustomer socialCustomer = SocialCustomer(
        email: body.email,
        socialId: body.uniqueId,
        firstName: signUpBody.fName,
        lastName: signUpBody.lName,
        password: signUpBody.password,
        phone: body.phone,
      );
      if (status.isSuccess) {
        List<int> _encoded = utf8.encode(signUpBody.password);
        String _data = base64Encode(_encoded); // hash password
        // setSocialCustomer(socialCustomer); // save customer to localStorage
        Get.toNamed(RouteHelper.getVerificationRoute(body.phone, token,
            RouteHelper.signUp, _data)); // navigate to phone verfication
      } else {
        googleSignOut();
        // setSocialCustomer(socialCustomer);
        showCustomSnackBar(status.message);
      }
    });
  }

  Future<void> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registerWithSocialMedia(socialLogInBody);
    if (response.statusCode == 200) {
      String _token = response.body['token'];
      if (Get.find<SplashController>().configModel.customerVerification &&
          response.body['is_phone_verified'] == 0) {
        Get.toNamed(RouteHelper.getVerificationRoute(
            socialLogInBody.phone, _token, RouteHelper.signUp, ''));
      } else {
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
        Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    _isLoading = false;
    update();
  }

  Future<ResponseModel> forgetPassword(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassword(email);

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText.tr);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyToken(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String resetToken, String number,
      String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response response = await authRepo.resetPassword(
        resetToken, number, password, confirmPassword);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText.tr);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.checkEmail(email);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyEmail(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String phone, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyPhone(phone, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateZone() async {
    Response response = await authRepo.updateZone();
    if (response.statusCode == 200) {
      // Nothing to do
    } else {
      ApiChecker.checkApi(response);
    }
  }

  String _verificationCode = '';

  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void logout() {
    authRepo.logout();
  }

  void googleSignOut() {
    authRepo.googleSignOut();
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(
      String number, String password, String countryCode) {
    authRepo.saveUserNumberAndPassword(number, password, countryCode);
  }

  String getUserNumber() {
    return authRepo.getUserNumber() ?? "";
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepo.setNotificationActive(isActive);
    update();
    return _notification;
  }

  Future<bool> checkIfGoogleUser() async {
    _isGoogleUser = await authRepo.isGoogleUser();
    update();
    return _isGoogleUser;
  }

  bool isSocialUserExist() {
    return authRepo.checkSocialUser();
  }

  List<SocialCustomer> getCurrentSocialCustomer() {
    return authRepo.getCurrentSocialCustomer();
  }

  void setSocialCustomer(SocialCustomer socialCustomer) {
    authRepo.setSocialCustomer(socialCustomer);
  }
}

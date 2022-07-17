import 'dart:convert';

import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/model/body/signup_body.dart';
import 'package:efood_multivendor/data/model/body/social_customer.dart';
import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/data/model/response/response_model.dart';
import 'package:efood_multivendor/data/repository/auth_repo.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
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
      responseModel = ResponseModel(false, response.statusText);
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

  Future<void> googleSignIn() async {
    try {
      final result = await authRepo.signInWithGoogle();
      final token = result.token;
      final user = result.userCredential.user;
      final isSocialExist =
          isSocialUserExist(); // check is there a table in local storage
      final List<SocialCustomer> socialCustomers =
          getCurrentSocialCustomer(); //get list of social accounts

      bool isCustomerExist = false;

      if (isSocialExist) {
        for (var customer in socialCustomers) {
          if (customer.email == user.email) {
            isCustomerExist = true;
          }
        }
      } // check if there social customer in local database

      if (!isCustomerExist || !isSocialExist) {
        //new user go to phone verification
        handleNewSocialUser(token, user);
      } else {
        //existing user login and go to location page
        handleSocialLogin(user, socialCustomers);
      }

      _isLoading = false;
      update();
    } catch (err) {
      _isLoading = false;
      update();
      print(err.toString());
      showCustomSnackBar("something went wrong");
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

  void handleSocialLogin(User user, List<SocialCustomer> socialCustomers) {
    SocialCustomer socialCustomer = SocialCustomer();

    for (var customer in socialCustomers) {
      if (customer.email == user.email) {
        socialCustomer = customer;
      }
    }
    login(socialCustomer.phone.trim(), socialCustomer.password.trim())
        .then((status) {
      if (status.isSuccess) {
        String _token = status.message.substring(1, status.message.length);
        if (Get.find<SplashController>().configModel.customerVerification &&
            int.parse(status.message[0]) == 0) {
          List<int> _encoded = utf8.encode(socialCustomer.password);
          String _data = base64Encode(_encoded);
          Get.toNamed(RouteHelper.getVerificationRoute(
              socialCustomer.phone, _token, RouteHelper.signUp, _data));
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
        password: body.uniqueId,
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
        setSocialCustomer(socialCustomer); // save customer to localStorage
        Get.toNamed(RouteHelper.getVerificationRoute(body.phone, token,
            RouteHelper.signUp, _data)); // navigate to phone verfication
      } else {
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
      responseModel = ResponseModel(false, response.statusText);
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
      responseModel = ResponseModel(false, response.statusText);
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

import 'dart:async';

import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/api/api_client.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/repository/splash_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/route_helper.dart';
import '../theme/font_styles.dart';
import '../util/app_constants.dart';
import 'auth_controller.dart';
import 'localization_controller.dart';
import 'location_controller.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({@required this.splashRepo});
  final cartController = Get.find<CartController>();
  ConfigModel _configModel = ConfigModel();
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;

  ConfigModel get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;

  Future<void> navigatorScreenRouting() async {
    Timer(Duration(seconds: 2), () {
      Get.offNamed(RouteHelper.getNavigatorRoute());
    });
  }

  Future<bool> getConfigData() async {
    _hasConnection = true;
    Response response = await splashRepo.getConfigData();
    bool _isSuccess = false;
    if (response.statusCode == 200) {
      _configModel = ConfigModel.fromJson(response.body);
      _isSuccess = true;
    } else {
      ApiChecker.checkApi(response);
      if (response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }

  bool showIntro() {
    return splashRepo.showIntro();
  }

  void intializeFontsStyle() {
    final languageCode = Get.find<LocalizationController>().locale.languageCode;
    Get.find<FontStyles>().setFonts(languageCode);
  }

  void handleSplashRouting(String orderId) {
    final authController = Get.find<AuthController>();
    final wishListController = Get.find<WishListController>();
    final locationController = Get.find<LocationController>();
    final userController = Get.find<UserController>();

    getConfigData().then((isSuccess) {
      if (isSuccess) {
        Timer(Duration(seconds: 1), () async {
          int _minimumVersion = 0;
          handleAppVersion(_minimumVersion); // set the version based on the os

          if (AppConstants.APP_VERSION < _minimumVersion ||
              configModel.maintenanceMode) {
            Get.offNamed(RouteHelper.getUpdateRoute(
                AppConstants.APP_VERSION < _minimumVersion));
          }

          if (orderId != null) {
            Get.offNamed(RouteHelper.getOrderDetailsRoute(int.parse(orderId)));
          } else {
            if (authController.isLoggedIn()) {
              authController.updateToken();
              await wishListController.getWishList();
              await userController.getUserInfo();
              checkUserAddress(locationController);
            } else {
              if (showIntro()) {
                // if (AppConstants.languages.length > 1) {
                //   Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                // } else {
                Get.offNamed(RouteHelper.getOnBoardingRoute());
              } else {
                // change to access location if not first time
                checkUserAddress(locationController);
              }
            }
          }
        });
      }
    });
  }

  void checkUserAddress(LocationController locationController) {
    if (locationController.getUserAddress() != null) {
      Get.offNamed(RouteHelper.getInitialRoute());
    } else {
      Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
    }
  }

  void handleAppVersion(int _minimumVersion) {
    if (GetPlatform.isAndroid) {
      _minimumVersion = configModel.appMinimumVersionAndroid;
    } else if (GetPlatform.isIOS) {
      _minimumVersion = configModel.appMinimumVersionIos;
    }
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  void disableIntro() {
    splashRepo.disableIntro();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }
}

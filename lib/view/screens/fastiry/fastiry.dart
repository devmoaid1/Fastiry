import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/connectivity_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../controller/wishlist_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../theme/dark_theme.dart';
import '../../../theme/light_theme.dart';
import '../../../util/app_constants.dart';
import '../../../util/messages.dart';

class FastiryApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final int orderID;
  FastiryApp({@required this.languages, @required this.orderID});

  void _route() {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          await Get.find<WishListController>().getWishList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      Get.find<CartController>().getCartData();
      _route();
    }

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? SizedBox()
              : GetBuilder<ConectivityController>(
                  builder: (connectivityController) {
                  return GetMaterialApp(
                    key: UniqueKey(),
                    title: AppConstants.APP_NAME,
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Get.key,
                    scrollBehavior: MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch
                      },
                    ),
                    theme: themeController.darkTheme ? dark : light,
                    locale: localizeController.locale,
                    translations: Messages(languages: languages),
                    fallbackLocale: Locale(
                        AppConstants.languages[0].languageCode,
                        AppConstants.languages[0].countryCode),
                    initialRoute: GetPlatform.isWeb
                        ? RouteHelper.getInitialRoute()
                        : RouteHelper.getSplashRoute(orderID),
                    getPages: RouteHelper.routes,
                    defaultTransition: Transition.topLevel,
                    transitionDuration: Duration(milliseconds: 500),
                  );
                });
        });
      });
    });
  }
}

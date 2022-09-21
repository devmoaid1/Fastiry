import 'dart:convert';

import 'package:dio/dio.dart';
import '/controller/auth_controller.dart';
import '/controller/banner_controller.dart';
import '/controller/campaign_controller.dart';
import '/controller/cart_controller.dart';
import '/controller/category_controller.dart';
import '/controller/coupon_controller.dart';
import '/controller/home_controller.dart';
import '/controller/localization_controller.dart';
import '/controller/location_controller.dart';

import '/controller/notification_controller.dart';
import '/controller/onboarding_controller.dart';
import '/controller/order_controller.dart';
import '/controller/product_controller.dart';
import '/controller/restaurant_controller.dart';
import '/controller/search_controller.dart';
import '/controller/splash_controller.dart';
import '/controller/theme_controller.dart';
import '/controller/user_controller.dart';
import '/controller/wallet_controller.dart';
import '/controller/wishlist_controller.dart';
import '/data/api/api_consumer.dart';
import '/data/api/dio_consumer.dart';
import '/data/api/interceptors.dart';
import '/data/repository/auth_repo.dart';
import '/data/repository/banner_repo.dart';
import '/data/repository/campaign_repo.dart';
import '/data/repository/cart_repo.dart';
import '/data/repository/coupon_repo.dart';
import '/data/repository/language_repo.dart';
import '/data/repository/location_repo.dart';
import '/data/repository/notification_repo.dart';
import '/data/repository/onboarding_repo.dart';
import '/data/repository/order_repo.dart';
import '/data/repository/product_repo.dart';
import '/data/repository/restaurant_repo.dart';
import '/data/repository/search_repo.dart';
import '/data/repository/splash_repo.dart';
import '/data/api/api_client.dart';
import '/data/repository/user_repo.dart';
import '/data/repository/wallet_repo.dart';
import '/data/repository/wishlist_repo.dart';
import '/data/services/connectivity_service.dart';
import '/theme/font_styles.dart';
import '/util/app_constants.dart';
import '/data/model/response/language_model.dart';
import '/view/screens/dashboard/dashboard_controller.dart';
import '/view/screens/fastiry_mart/mart_viewModel.dart';
import '/view/screens/restaurant/restaurant_viewModel.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../controller/connectivity_controller.dart';
import '../data/repository/category_repo.dart';
import '../view/screens/category/category_viewModel.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => Dio());
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  Get.lazyPut<ApiConsumer>(() => DioConsumer(client: Get.find()));

  Get.lazyPut(() => AppInterceptors());
  Get.lazyPut(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));

  // Repository
  Get.lazyPut(
      () => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(
      () => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()), fenix: true);
  Get.lazyPut(() => RestaurantRepo(apiClient: Get.find()));
  Get.lazyPut(() => WishListRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => SearchRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(
      () => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() =>
      NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CampaignRepo(apiClient: Get.find()));
  Get.lazyPut(() => WalletRepo(apiClient: Get.find()));
  Get.lazyPut(() => ConnectivityService());

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(
      sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => OnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  Get.lazyPut(
      () => CartController(cartRepo: Get.find(), restaurantRepo: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantRepo: Get.find()));
  Get.lazyPut(() =>
      WishListController(wishListRepo: Get.find(), productRepo: Get.find()));
  Get.lazyPut(() => SearchController(searchRepo: Get.find()));
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => CampaignController(campaignRepo: Get.find()));
  Get.lazyPut(() => WalletController(walletRepo: Get.find()));
  Get.lazyPut(() => HomeController());
  Get.lazyPut(() => DashBoardController());
  Get.lazyPut(() => ConectivityController());

  // viewModels
  Get.lazyPut(() => MartViewModel(restaurantRepo: Get.find()), fenix: true);
  Get.lazyPut(
      () => RestuarantViewModel(
          categoryRepo: Get.find(), restaurantRepo: Get.find()),
      fenix: true);
  Get.lazyPut(() => CategoryViewModel(categoryRepo: Get.find()), fenix: true);

  // font styles

  Get.lazyPut(() => FontStyles());

  // Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        _json;
  }
  return _languages;
}

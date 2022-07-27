import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';
import 'banner_controller.dart';
import 'campaign_controller.dart';
import 'category_controller.dart';
import 'notification_controller.dart';
import 'restaurant_controller.dart';

class HomeController extends GetxController implements GetxService {
  bool _isLoading;

  bool get isLoading => _isLoading;

  final bannerController = Get.find<BannerController>();
  final authController = Get.find<AuthController>();
  final splashController = Get.find<SplashController>();
  final campainController = Get.find<CampaignController>();
  final categoryController = Get.find<CategoryController>();
  final restaurantController = Get.find<RestaurantController>();
  final productController = Get.find<ProductController>();
  final userController = Get.find<UserController>();
  final notificationController = Get.find<NotificationController>();

  void setIsLoading(bool value) {
    _isLoading = value;
    update();
  }

  Future<void> loadData(bool reload) async {
    setIsLoading(true);
    bannerController.getBannerList(reload);
    categoryController.getCategoryList(reload);
    if (splashController.configModel.popularRestaurant == 1) {
      restaurantController.getPopularRestaurantList(reload, 'all', false);
    }
    campainController.getItemCampaignList(reload);
    if (splashController.configModel.popularFood == 1) {
      productController.getPopularProductList(reload, 'all', false);
    }
    if (splashController.configModel.newRestaurant == 1) {
      restaurantController.getLatestRestaurantList(reload, 'all', false);
    }
    if (splashController.configModel.mostReviewedFoods == 1) {
      productController.getReviewedProductList(reload, 'all', false);
    }
    restaurantController.getRestaurantList(1, reload);
    if (authController.isLoggedIn()) {
      userController.getUserInfo();
      notificationController.getNotificationList(reload);
    }

    setIsLoading(false);
  }

  Future<void> refresh() async {
    await Get.find<BannerController>().getBannerList(false);
    await Get.find<CategoryController>().getCategoryList(false);
    await Get.find<RestaurantController>()
        .getPopularRestaurantList(true, 'all', false);
    await Get.find<CampaignController>().getItemCampaignList(false);
    await Get.find<ProductController>()
        .getPopularProductList(true, 'all', false);
    await Get.find<RestaurantController>()
        .getLatestRestaurantList(true, 'all', false);
    await Get.find<ProductController>()
        .getReviewedProductList(true, 'all', false);
    await Get.find<RestaurantController>().getRestaurantList(1, false);
    if (Get.find<AuthController>().isLoggedIn()) {
      await Get.find<UserController>().getUserInfo();
      await Get.find<NotificationController>().getNotificationList(false);
    }
  }
}
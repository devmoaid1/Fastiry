import '/controller/auth_controller.dart';
import '/controller/banner_controller.dart';
import '/controller/campaign_controller.dart';
import '/controller/cart_controller.dart';
import '/controller/category_controller.dart';
import '/controller/home_controller.dart';
import '/controller/notification_controller.dart';
import '/controller/product_controller.dart';
import '/controller/restaurant_controller.dart';
import '/controller/splash_controller.dart';
import '/controller/user_controller.dart';
import '/helper/responsive_helper.dart';
import '/view/base/web_menu_bar.dart';
import '/view/screens/home/theme1/theme1_home_screen.dart';
import '/view/screens/home/web_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  static Future<void> loadData(bool reload) async {
    Get.find<BannerController>().getBannerList(reload);
    Get.find<CategoryController>().getCategoryList(reload);
    if (Get.find<SplashController>().configModel.popularRestaurant == 1) {
      Get.find<RestaurantController>()
          .getPopularRestaurantList(reload, 'all', false);
    }
    Get.find<CampaignController>().getItemCampaignList(reload);
    if (Get.find<SplashController>().configModel.popularFood == 1) {
      Get.find<ProductController>().getPopularProductList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel.newRestaurant == 1) {
      Get.find<RestaurantController>()
          .getLatestRestaurantList(reload, 'all', false);
    }
    if (Get.find<SplashController>().configModel.mostReviewedFoods == 1) {
      Get.find<ProductController>()
          .getReviewedProductList(reload, 'all', false);
    }
    Get.find<RestaurantController>().getRestaurantList(1, reload);
    if (Get.find<AuthController>().isLoggedIn()) {
      Get.find<UserController>().getUserInfo();
      Get.find<NotificationController>().getNotificationList(reload);
    }
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final homeController = Get.find<HomeController>();
  final cartController = Get.find<CartController>();
  @override
  void initState() {
    super.initState();
    // init();
    homeController.loadData(false);
  }

  void init() async {
    await homeController.loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () async {
              await homeController.refresh();
            },
            child: ResponsiveHelper.isDesktop(context)
                ? WebHomeScreen(
                    scrollController: _scrollController,
                  )
                : Theme1HomeScreen(
                    scrollController: _scrollController,
                  )),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

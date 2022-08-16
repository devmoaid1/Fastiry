import 'package:efood_multivendor/theme/font_styles.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/services_instances.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../base/no_internet_screen.dart';

class NavigatorScreen extends StatefulWidget {
  NavigatorScreen({Key key}) : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  final splashController = Get.find<SplashController>();
  final cartController = Get.find<CartController>();
  @override
  void initState() {
    if (connectivityService.isConnected.isTrue) {
      splashController.handleSplashRouting(null);
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: connectivityService.isConnected.isTrue
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomLoader(),
                    SizedBox(
                      height: 20,
                    ),
                    Text("fetching_data".tr,
                        style: Get.find<FontStyles>().poppinsMedium.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 5))
                  ],
                ),
              )
            : NoInternetScreen(
                child: NavigatorScreen(),
              ),
      );
    });
  }
}
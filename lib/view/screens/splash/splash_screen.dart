import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller.dart';
import '../../../util/services_instances.dart';

class SplashScreen extends StatefulWidget {
  final String orderID;
  SplashScreen({@required this.orderID});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  final splashController = Get.find<SplashController>();
  final cartController = Get.find<CartController>();
  @override
  void initState() {
    super.initState();

    splashController.intializeFontsStyle();
    connectivityController.initConnectionStream();
    splashController.initSharedData();
    cartController.getCartData();
    cartController.getCartSubTotal();
    splashController.handleSplashRouting(null);
    // splashController.navigatorScreenRouting();

    // bool _firstTime = true;
    // _onConnectivityChanged = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   if (!_firstTime) {
    //     bool isNotConnected = result != ConnectivityResult.wifi &&
    //         result != ConnectivityResult.mobile;
    //     isNotConnected
    //         ? SizedBox()
    //         : ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: isNotConnected ? Colors.red : Colors.green,
    //       duration: Duration(seconds: isNotConnected ? 6000 : 3),
    //       content: Text(
    //         isNotConnected ? 'no_connection'.tr : 'connected'.tr,
    //         textAlign: TextAlign.center,
    //       ),
    //     ));
    //     if (!isNotConnected) {
    //       splashController.handleSplashRouting(widget.orderID);
    //     }
    //   }
    //   _firstTime = false;
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Get.isDarkMode ? Color(0xff101010) : Colors.white,
        key: _globalKey,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Images.fastiryRed,
                height: Dimensions.blockscreenVertical * 35),
          ],
        )));
  }
}

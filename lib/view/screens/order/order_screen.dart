import '/controller/auth_controller.dart';
import '/controller/order_controller.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/not_logged_in_screen.dart';
import '/view/screens/order/widget/order_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
      Get.find<OrderController>().getRunningOrders(1);
      Get.find<OrderController>().getHistoryOrders(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: 'my_orders'.tr, isBackButtonExist: true),
      body: _isLoggedIn
          ? GetBuilder<OrderController>(
              builder: (orderController) {
                return Column(children: [
                  Center(
                    child: Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorWeight: 3,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: Theme.of(context).disabledColor,
                        unselectedLabelStyle: Get.find<FontStyles>()
                            .poppinsRegular
                            .copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeSmall),
                        labelStyle: Get.find<FontStyles>().poppinsBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(context).primaryColor),
                        tabs: [
                          Tab(text: 'running'.tr),
                          Tab(text: 'order_history'.tr),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: _tabController,
                    children: [
                      OrderView(isRunning: true),
                      OrderView(isRunning: false),
                    ],
                  )),
                ]);
              },
            )
          : NotLoggedInScreen(),
    );
  }
}

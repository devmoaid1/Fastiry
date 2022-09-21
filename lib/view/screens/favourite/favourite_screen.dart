import '/controller/auth_controller.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/not_logged_in_screen.dart';
import '/view/screens/favourite/widget/fav_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    print(Dimensions.orientation);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: 'favourite'.tr, isBackButtonExist: false),
      body: Get.find<AuthController>().isLoggedIn()
          ? SafeArea(
              child: Column(children: [
              Container(
                width: Dimensions.WEB_MAX_WIDTH,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).dividerColor,
                  unselectedLabelStyle: Get.find<FontStyles>()
                      .poppinsRegular
                      .copyWith(
                          color: Theme.of(context).disabledColor,
                          fontSize: Dimensions.fontSizeSmall),
                  labelStyle: Get.find<FontStyles>().poppinsBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(text: 'food'.tr),
                    Tab(text: 'Restaurants'.tr),
                  ],
                ),
              ),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                children: [
                  FavItemView(isRestaurant: false),
                  FavItemView(isRestaurant: true),
                ],
              )),
            ]))
          : NotLoggedInScreen(),
    );
  }
}

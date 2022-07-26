import 'dart:async';

import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_controller.dart';
import 'package:efood_multivendor/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:efood_multivendor/view/screens/favourite/favourite_screen.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/menu/menu_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      FavouriteScreen(),
      OrderScreen(),
      Container(),
    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  final dashBoardController = Get.find<DashBoardController>();
  @override
  Widget build(BuildContext context) {
    print(widget.pageIndex);

    return WillPopScope(
      onWillPop: () async {
        if (dashBoardController.currentIndex != 0) {
          dashBoardController.setIndex(0);
          return false;
        } else {
          if (_canExit) {
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        //
        bottomNavigationBar: ResponsiveHelper.isDesktop(context)
            ? SizedBox()
            : BottomNavigationBar(
                elevation: 2,
                selectedItemColor: Theme.of(context).primaryColor,
                currentIndex: dashBoardController.currentIndex,
                type: BottomNavigationBarType.fixed,
                // showUnselectedLabels: true,
                unselectedItemColor: Colors.grey,
                selectedLabelStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: Theme.of(context).primaryColor),
                unselectedLabelStyle:
                    TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                onTap: (index) {
                  _setPage(index);
                  if (index == 3) {
                    Get.bottomSheet(MenuScreen(),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true);
                  }
                },
                items: [
                  BottomNavigationBarItem(
                      label: 'home',
                      icon: BottomNavItem(
                          iconData: Icons.favorite,
                          iconPath: Images.homeIcon,
                          iconName: 'wishlist',
                          isSelected: dashBoardController.currentIndex == 0,
                          onTap: () {})),
                  BottomNavigationBarItem(
                      label: 'wishlist',
                      icon: BottomNavItem(
                          iconData: Icons.favorite,
                          iconPath: Images.favouritesIcon,
                          iconName: 'wishlist',
                          isSelected: dashBoardController.currentIndex == 1,
                          onTap: () {})),
                  BottomNavigationBarItem(
                      label: 'orders',
                      icon: BottomNavItem(
                          iconData: Icons.shopping_bag,
                          iconPath: Images.ordersIcon,
                          iconName: 'orders',
                          isSelected: dashBoardController.currentIndex == 2,
                          onTap: () {})),
                  BottomNavigationBarItem(
                      label: 'menu',
                      icon: BottomNavItem(
                          iconData: Icons.menu,
                          iconPath: Images.menuIcon,
                          iconName: 'menu',
                          isSelected: dashBoardController.currentIndex == 3,
                          onTap: () {})),
                ],
              ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
    });
    dashBoardController.setIndex(pageIndex);
  }
}

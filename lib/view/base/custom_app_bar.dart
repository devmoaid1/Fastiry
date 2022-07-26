import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/cart_widget.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool showCart;
  final bool isWithLogo;
  CustomAppBar(
      {@required this.title,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.showCart = false,
      this.isWithLogo = false});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isDesktop
        ? WebMenuBar()
        : AppBar(
            title: isWithLogo
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Images.fastiryNewIconRed,
                        height: 70,
                      ),
                      Image.asset(
                        Images.fastiryNewIconType,
                        height: 100,
                      ),
                    ],
                  )
                : Text(title,
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: lightGreyTextColor)),
            centerTitle: true,
            leading: isBackButtonExist
                ? IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).primaryColor,
                    onPressed: () => onBackPressed != null
                        ? onBackPressed()
                        : Navigator.pop(context),
                  )
                : SizedBox(),
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            actions: showCart
                ? [
                    IconButton(
                      onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
                      icon: CartWidget(
                          color: Theme.of(context).textTheme.bodyText1.color,
                          size: 25),
                    )
                  ]
                : null,
          );
  }

  @override
  Size get preferredSize =>
      Size(Dimensions.WEB_MAX_WIDTH, GetPlatform.isDesktop ? 70 : 50);
}

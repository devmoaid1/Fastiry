import '/helper/route_helper.dart';
import '/util/dimensions.dart';
import '/view/base/cart_widget.dart';
import '/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';
import '../../util/images.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool showCart;
  final bool isWithLogo;
  final bool isWithSpace;
  final Color backgroundColor;
  CustomAppBar(
      {@required this.title,
      this.backgroundColor,
      this.isBackButtonExist = true,
      this.onBackPressed,
      this.showCart = false,
      this.isWithSpace = false,
      this.isWithLogo = false});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isDesktop
        ? WebMenuBar()
        : AppBar(
            title: isWithLogo
                ? Row(
                    mainAxisAlignment: isWithSpace
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      isWithSpace
                          ? SizedBox(
                              width: Dimensions.blockscreenHorizontal * 12,
                            )
                          : Container(),
                      Get.locale.languageCode != "en"
                          ? Image.asset(
                              Images.fastiryLogoTypeArabic,
                              width: Dimensions.blockscreenVertical * 15,
                              height: Dimensions.blockscreenVertical * 15,
                            )
                          : Container(),
                      Image.asset(
                        Images.fastiryLogoRed,
                        height: Dimensions.blockscreenVertical * 10,
                      ),
                      Get.locale.languageCode == "en"
                          ? Image.asset(
                              Images.fastiryLogoType,
                              width: Dimensions.blockscreenVertical * 15,
                              height: Dimensions.blockscreenVertical * 15,
                            )
                          : Container()
                    ],
                  )
                : Text(title,
                    style: Get.find<FontStyles>().poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                        color: Theme.of(context).dividerColor)),
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
            backgroundColor: backgroundColor != null
                ? backgroundColor
                : Theme.of(context).backgroundColor,
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

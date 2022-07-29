import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/wishlist_controller.dart';
import '../../../helper/route_helper.dart';
import '../../base/confirmation_dialog.dart';
import './widget/menu_item.dart';
import '../../../util/images.dart';

class MenuScreenNew extends StatefulWidget {
  const MenuScreenNew({Key key}) : super(key: key);

  @override
  State<MenuScreenNew> createState() => _MenuScreenNewState();
}

class _MenuScreenNewState extends State<MenuScreenNew> {
  final authController = Get.find<AuthController>();
  final userContoller = Get.find<UserController>();

  bool isLogged;
  @override
  void initState() {
    super.initState();
    isLogged = authController.isLoggedIn();

    if (isLogged) {
      userContoller.getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.blockscreenVertical * 4,
            horizontal: Dimensions.blockscreenHorizontal * 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLogged
                  ? ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: Center(
                          child: Text(
                            userContoller.userInfoModel.fName.substring(0, 1),
                            style: poppinsMedium.copyWith(
                                fontSize: Dimensions.blockscreenHorizontal * 5),
                          ),
                        ),
                      ),
                      title: Text(
                        userContoller.userInfoModel.fName +
                            " " +
                            userContoller.userInfoModel.lName,
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 4),
                      ),
                    )
                  : ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: Dimensions.blockscreenHorizontal * 7),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.grey[300],
                        child: Center(
                          child: Text(
                            "G",
                            style: poppinsMedium.copyWith(
                              fontSize: Dimensions.blockscreenHorizontal * 5,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "Guest",
                        style: poppinsRegular.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 4),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Get.toNamed(RouteHelper.getProfileRoute());
                        },
                        child: SvgPicture.asset(
                          Images.settingsIcon,
                          width: 25,
                          height: 25,
                          color: lightGreyTextColor,
                        ),
                      ),
                    ),
              SizedBox(height: Dimensions.blockscreenVertical * 3),
              MenuSelection(
                iconPath: Images.notificationIcon,
                label: 'Notification',
                onTap: () {
                  Get.toNamed(RouteHelper.getNotificationRoute());
                },
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.discountIcon,
                label: 'Offers',
                onTap: () {
                  Get.toNamed(RouteHelper.getCouponRoute());
                },
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.privacyIcon,
                label: 'Privacy Policy',
                onTap: () async {
                  final route = RouteHelper.getHtmlRoute('privacy-policy');
                  if (await canLaunchUrl(Uri.parse(route))) {
                    launchUrl(Uri.parse(route));
                  }
                },
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.termsIcon,
                label: 'Terms and Conditions',
                onTap: () async {
                  final route = RouteHelper.getHtmlRoute('terms-and-condition');
                  if (await canLaunchUrl(Uri.parse(route))) {
                    launchUrl(Uri.parse(route));
                  }
                },
              ),
              MenuDivider(),
              isLogged
                  ? MenuSelection(
                      iconPath: Images.logoutIcon,
                      label: 'Logout',
                      onTap: () {
                        Get.dialog(
                            ConfirmationDialog(
                                icon: Images.support,
                                description: 'are_you_sure_to_logout'.tr,
                                isLogOut: true,
                                onYesPressed: () {
                                  Get.find<AuthController>().clearSharedData();
                                  Get.find<CartController>().clearCartList();
                                  Get.find<WishListController>().removeWishes();
                                  Get.offAllNamed(RouteHelper.getSignInRoute(
                                      RouteHelper.splash));
                                }),
                            useSafeArea: false);
                      },
                    )
                  : MenuSelection(
                      iconPath: Images.loginIcon,
                      label: 'Login',
                      onTap: () {
                        Get.find<WishListController>().removeWishes();
                        Get.toNamed(
                            RouteHelper.getSignInRoute(RouteHelper.main));
                      },
                    ),
            ],
          ),
        ),
      )),
    );
  }
}

class MenuDivider extends StatelessWidget {
  const MenuDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.blockscreenVertical * 2,
          horizontal: Dimensions.blockscreenHorizontal * 3),
      child: Divider(
        color: lightGreyTextColor,
        thickness: 0.3,
        height: 1,
      ),
    );
  }
}

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/dimensions.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/wishlist_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../theme/font_styles.dart';
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
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Center(
                    child: Text(
                      (isLogged && userContoller.userInfoModel != null)
                          ? userContoller.userInfoModel.fName.substring(0, 1)
                          : 'G',
                      style: Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 5),
                    ),
                  ),
                ),
                title: Text(
                  (isLogged && userContoller.userInfoModel != null)
                      ? userContoller.userInfoModel.fName +
                          " " +
                          userContoller.userInfoModel.lName
                      : "guest".tr,
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                      fontSize: Get.locale.languageCode == "en"
                          ? Dimensions.blockscreenHorizontal * 4
                          : Dimensions.blockscreenHorizontal * 5),
                ),
                trailing: InkWell(
                  onTap: () {
                    Get.toNamed(RouteHelper.getProfileRoute());
                  },
                  child: SvgPicture.asset(
                    Images.settingsIcon,
                    width: 25,
                    height: 25,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.blockscreenVertical * 3),
              MenuSelection(
                iconPath: Images.notificationIcon,
                label: 'notification'.tr,
                onTap: () {
                  Get.toNamed(RouteHelper.getNotificationRoute());
                },
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.discountIcon,
                label: 'coupon'.tr,
                onTap: () {
                  Get.toNamed(RouteHelper.getCouponRoute());
                },
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.privacyIcon,
                label: 'privacy_policy'.tr,
                onTap: () async {
                  if (await canLaunchUrl(
                      Uri.parse(AppConstants.privacyAndPolicyUrl))) {
                    launchUrl(Uri.parse(AppConstants.privacyAndPolicyUrl));
                  }
                },
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.termsIcon,
                label: 'terms_conditions'.tr,
                onTap: () async {
                  if (await canLaunchUrl(
                      Uri.parse(AppConstants.termsAndConditionsUrl))) {
                    launchUrl(Uri.parse(AppConstants.termsAndConditionsUrl));
                  }
                },
              ),
              MenuDivider(),
              isLogged
                  ? MenuSelection(
                      iconPath: Images.logoutIcon,
                      label: 'logout'.tr,
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
                      label: 'login_menu'.tr,
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
        color: Theme.of(context).dividerColor,
        thickness: 0.3,
        height: 1,
      ),
    );
  }
}

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_button.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _showWalletCard =
        Get.find<SplashController>().configModel.customerWalletStatus == 1 ||
            Get.find<SplashController>().configModel.loyaltyPointStatus == 1;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? WebMenuBar()
          : CustomAppBar(title: '', isWithLogo: true),
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null)
            ? Center(child: CircularProgressIndicator())
            : ProfileBgWidget(
                // backButton: true,
                // circularImage: Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //         width: 2, color: Theme.of(context).cardColor),
                //     shape: BoxShape.circle,
                //   ),
                //   alignment: Alignment.center,
                //   child: ClipOval(
                //       child: CustomImage(
                //     image:
                //         '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                //         '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                //     height: 100,
                //     width: 100,
                //     fit: BoxFit.cover,
                //   )),
                // ),
                mainWidget: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Scrollbar(
                          child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.blockscreenVertical * 2),
                                child: Container(
                                  width: Dimensions.WEB_MAX_WIDTH,
                                  color: Theme.of(context).cardColor,
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                      .blockscreenHorizontal *
                                                  4,
                                              vertical: Dimensions
                                                      .blockscreenVertical *
                                                  1),
                                          child: Text(
                                            "Settings",
                                            textAlign: TextAlign.left,
                                            style: poppinsRegular.copyWith(
                                                color: lightGreyTextColor,
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    7),
                                          ),
                                        ),
                                        ListTile(
                                          leading: SvgPicture.asset(
                                            Images.profileIcon,
                                            width: Dimensions
                                                    .blockscreenHorizontal *
                                                7,
                                            height: Dimensions
                                                    .blockscreenHorizontal *
                                                7,
                                            color: lightGreyTextColor,
                                          ),
                                          title: Text(
                                            _isLoggedIn
                                                ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}'
                                                : 'guest'.tr,
                                            style: poppinsRegular.copyWith(
                                                color: lightGreyTextColor,
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    4),
                                          ),
                                          trailing: Text(
                                            _isLoggedIn
                                                ? "Edit Profile"
                                                : "Login/signup",
                                            style: poppinsMedium.copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    3.3,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    4),
                                        _isLoggedIn
                                            ? Column(children: [
                                                Row(children: [
                                                  ProfileCard(
                                                      title: 'since_joining'.tr,
                                                      data:
                                                          '${userController.userInfoModel.memberSinceDays} ${'days'.tr}'),
                                                  SizedBox(
                                                      width: Dimensions
                                                          .PADDING_SIZE_SMALL),
                                                  ProfileCard(
                                                      title: 'total_order'.tr,
                                                      data: userController
                                                          .userInfoModel
                                                          .orderCount
                                                          .toString()),
                                                ]),
                                                SizedBox(
                                                    height: _showWalletCard
                                                        ? Dimensions
                                                            .PADDING_SIZE_SMALL
                                                        : 0),
                                                _showWalletCard
                                                    ? Row(children: [
                                                        Get.find<SplashController>()
                                                                    .configModel
                                                                    .customerWalletStatus ==
                                                                1
                                                            ? ProfileCard(
                                                                title:
                                                                    'wallet_amount'
                                                                        .tr,
                                                                data: PriceConverter.convertPrice(
                                                                    userController
                                                                        .userInfoModel
                                                                        .walletBalance),
                                                              )
                                                            : SizedBox.shrink(),
                                                        SizedBox(
                                                            width: Get.find<SplashController>()
                                                                            .configModel
                                                                            .customerWalletStatus ==
                                                                        1 &&
                                                                    Get.find<SplashController>()
                                                                            .configModel
                                                                            .loyaltyPointStatus ==
                                                                        1
                                                                ? Dimensions
                                                                    .PADDING_SIZE_SMALL
                                                                : 0.0),
                                                        Get.find<SplashController>()
                                                                    .configModel
                                                                    .loyaltyPointStatus ==
                                                                1
                                                            ? ProfileCard(
                                                                title:
                                                                    'loyalty_points'
                                                                        .tr,
                                                                data: userController
                                                                            .userInfoModel
                                                                            .loyaltyPoint !=
                                                                        null
                                                                    ? userController
                                                                        .userInfoModel
                                                                        .loyaltyPoint
                                                                        .toString()
                                                                    : '0',
                                                              )
                                                            : SizedBox.shrink(),
                                                      ])
                                                    : SizedBox(),
                                              ])
                                            : SizedBox(),
                                        SizedBox(height: _isLoggedIn ? 30 : 0),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                      .blockscreenHorizontal *
                                                  4,
                                              vertical: Dimensions
                                                      .blockscreenVertical *
                                                  3),
                                          child: Text(
                                            "App Settings",
                                            textAlign: TextAlign.left,
                                            style: poppinsRegular.copyWith(
                                                color: lightGreyTextColor,
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    5),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                      .blockscreenHorizontal *
                                                  4),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                Images.languageIcon,
                                                color: lightGreyTextColor,
                                                width: 27,
                                                height: 27,
                                              ),
                                              SizedBox(
                                                width: Dimensions
                                                        .blockscreenHorizontal *
                                                    4,
                                              ),
                                              Text(
                                                "Langauge",
                                                style: poppinsRegular.copyWith(
                                                    color: lightGreyTextColor),
                                              ),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    Get.locale.languageCode ==
                                                            "en"
                                                        ? "English"
                                                        : "العربية",
                                                    style: poppinsRegular.copyWith(
                                                        color:
                                                            lightGreyTextColor),
                                                  ),
                                                  SizedBox(
                                                    width: Dimensions
                                                            .blockscreenHorizontal *
                                                        3,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.toNamed(RouteHelper
                                                          .getLanguageRoute(
                                                              RouteHelper
                                                                  .profile));
                                                    },
                                                    child: Text(
                                                      "change",
                                                      style: poppinsMedium
                                                          .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    3),
                                        ProfileButton(
                                            iconPath: Images.darkModeIcon,
                                            title: 'dark_mode'.tr,
                                            isButtonActive: Get.isDarkMode,
                                            onTap: () {
                                              Get.find<ThemeController>()
                                                  .toggleTheme();
                                            }),
                                        SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_LARGE),
                                      ]),
                                ),
                              )),
                        ),
                      ),
                      Container(
                        height: Dimensions.blockscreenVertical * 6,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${'version'.tr}:',
                                  style: poppinsRegular.copyWith(
                                      fontSize:
                                          Dimensions.blockscreenHorizontal * 3,
                                      color: lightGreyTextColor)),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(AppConstants.APP_VERSION.toString(),
                                  style: poppinsMedium.copyWith(
                                      color: lightGreyTextColor,
                                      fontSize:
                                          Dimensions.blockscreenHorizontal *
                                              3)),
                            ]),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}

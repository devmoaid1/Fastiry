import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/controller/user_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/menu/widget/menu_item.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:efood_multivendor/view/screens/profile/widget/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';
import '../../../theme/font_styles.dart';

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
    // final bool _showWalletCard =
    //     Get.find<SplashController>().configModel.customerWalletStatus == 1 ||
    //         Get.find<SplashController>().configModel.loyaltyPointStatus == 1;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? WebMenuBar()
          : CustomAppBar(title: '', isWithLogo: true),
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null)
            ? Center(child: CircularProgressIndicator())
            : ProfileBgWidget(
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
                                            "settings".tr,
                                            textAlign: TextAlign.left,
                                            style: Get.find<FontStyles>()
                                                .poppinsRegular
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .dividerColor,
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
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                          title: Text(
                                            _isLoggedIn
                                                ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}'
                                                : 'guest'.tr,
                                            style: Get.find<FontStyles>()
                                                .poppinsRegular
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                    fontSize: Dimensions
                                                            .blockscreenHorizontal *
                                                        4),
                                          ),
                                          trailing: InkWell(
                                            onTap: () {
                                              if (_isLoggedIn) {
                                                Get.toNamed(RouteHelper
                                                    .getUpdateProfileRoute());
                                              } else {
                                                Get.offNamed(
                                                    RouteHelper.getSignInRoute(
                                                        'splash'));
                                              }
                                            },
                                            child: Text(
                                              _isLoggedIn
                                                  ? "profile".tr
                                                  : "login/signUp".tr,
                                              style: Get.find<FontStyles>()
                                                  .poppinsMedium
                                                  .copyWith(
                                                      fontSize: Dimensions
                                                              .blockscreenHorizontal *
                                                          3.3,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                            ),
                                          ),
                                        ),
                                        MenuSelection(
                                          iconPath: Images.walletIcon,
                                          label: "wallet".tr,
                                          onTap: () {
                                            Get.toNamed(
                                                RouteHelper.getWalletRoute(
                                                    true));
                                          },
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    4),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                      .blockscreenHorizontal *
                                                  4,
                                              vertical: Dimensions
                                                      .blockscreenVertical *
                                                  3),
                                          child: Text(
                                            "preferences".tr,
                                            textAlign: TextAlign.left,
                                            style: Get.find<FontStyles>()
                                                .poppinsRegular
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .dividerColor,
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
                                                color: Theme.of(context)
                                                    .dividerColor,
                                                width: 27,
                                                height: 27,
                                              ),
                                              SizedBox(
                                                width: Dimensions
                                                        .blockscreenHorizontal *
                                                    4,
                                              ),
                                              Text(
                                                'language'.tr,
                                                style: Get.find<FontStyles>()
                                                    .poppinsRegular
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .dividerColor),
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
                                                    style: Get.find<
                                                            FontStyles>()
                                                        .poppinsRegular
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .dividerColor),
                                                  ),
                                                  SizedBox(
                                                    width: Dimensions
                                                            .blockscreenHorizontal *
                                                        3,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.toNamed(
                                                        RouteHelper
                                                            .getLanguageRoute(
                                                                'menu'),
                                                      );
                                                    },
                                                    child: Text(
                                                      "change".tr,
                                                      style: Get.find<
                                                              FontStyles>()
                                                          .poppinsMedium
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
                                  style: Get.find<FontStyles>()
                                      .poppinsRegular
                                      .copyWith(
                                          fontSize:
                                              Dimensions.blockscreenHorizontal *
                                                  3,
                                          color: lightGreyTextColor)),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(AppConstants.APP_VERSION.toString(),
                                  style: Get.find<FontStyles>()
                                      .poppinsMedium
                                      .copyWith(
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

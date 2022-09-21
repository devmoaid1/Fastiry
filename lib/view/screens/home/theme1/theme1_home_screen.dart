import 'package:badges/badges.dart';
import '/controller/auth_controller.dart';
import '/view/screens/home/theme1/Fasteriy_mart_ad.dart';
import '/view/screens/home/widget/fastiry_options.dart';
import '/view/screens/home/widget/not_logged_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '/controller/location_controller.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/dimensions.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/images.dart';
import 'banner_view1.dart';
import 'category_view1.dart';

class Theme1HomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  const Theme1HomeScreen({@required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            toolbarHeight: Dimensions.blockscreenVertical * 11,
            // expandedHeight: Dimensions.blockscreenVertical * 8,
            floating: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: ResponsiveHelper.isDesktop(context)
                ? Colors.transparent
                : Theme.of(context).backgroundColor,

            title: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 6,
                  // ),
                  Text(
                    "deliver_to".tr,
                    style: Get.find<FontStyles>().poppinsMedium.copyWith(
                        color: Theme.of(context).dividerColor,
                        fontSize: Dimensions.blockscreenHorizontal * 3.5),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  GetBuilder<LocationController>(builder: (locationController) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed(
                              RouteHelper.getAccessLocationRoute('home')),
                          child: Row(
                            children: [
                              Image.asset(
                                Images.pin_marker,
                                color: Theme.of(context).primaryColor,
                                height: Dimensions.blockscreenHorizontal * 5,
                              ),
                              SizedBox(
                                  width: Dimensions.blockscreenHorizontal * 3),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: Dimensions.screenWidth * 0.58,
                                ),
                                child: Text(
                                  locationController
                                              .getUserAddress()
                                              .address
                                              .length <
                                          30
                                      ? locationController
                                          .getUserAddress()
                                          .address
                                      : locationController
                                          .getUserAddress()
                                          .address
                                          .substring(0, 30)
                                          .trim(),
                                  style: Get.find<FontStyles>()
                                      .poppinsRegular
                                      .copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeSmall,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).disabledColor,
                              ),
                            ],
                          ),
                        ),
                        GetBuilder<CartController>(builder: (cartController) {
                          return cartController.cartList.length > 0
                              ? InkWell(
                                  onTap: () =>
                                      Get.toNamed(RouteHelper.getCartRoute()),
                                  child: Badge(
                                    showBadge: true,
                                    position: Get.locale.languageCode == "en"
                                        ? BadgePosition.topEnd()
                                        : BadgePosition.topStart(top: -5),
                                    padding: EdgeInsets.all(8),
                                    elevation: 0,
                                    badgeColor: Colors.red,
                                    badgeContent: Center(
                                      child: Text(
                                        cartController.cartList.length
                                            .toString(),
                                        style: Get.find<FontStyles>()
                                            .poppinsRegular
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 12),
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      Images.cartIcon,
                                      width: 25,
                                      height: 25,
                                    ),
                                  ),
                                )
                              : SizedBox();
                        })
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          // sections
          SliverToBoxAdapter(
            child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !Get.find<AuthController>().isLoggedIn()
                        ? NotLoggedCard()
                        : FastriyMartAdSection(),
                    FastiryOptions(),
                    BannerView1(),
                    CategoryView1(),
                    // PopularStoreView1(isPopular: false),
                    // ItemCampaignView1(),
                    // BestReviewedItemView(),
                    // PopularStoreView1(isPopular: true),
                    // PopularItemView1(isPopular: true),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       vertical: Dimensions.blockscreenVertical * 3,
                    //       horizontal: Dimensions.blockscreenHorizontal * 3),
                    //   child: Row(children: [
                    //     Expanded(
                    //         child: Text(
                    //       'all_restaurants'.tr,
                    //       style: poppinsRegular.copyWith(
                    //           fontSize: Dimensions.blockscreenHorizontal * 3.5,
                    //           fontWeight: FontWeight.w600,
                    //           color: Theme.of(context).dividerColor),
                    //     )),
                    //     FilterView(),
                    //   ]),
                    // ),
                    // GetBuilder<RestaurantController>(builder: (restaurantController) {
                    //   return PaginatedListView(
                    //     scrollController: scrollController,
                    //     totalSize: restaurantController.restaurantModel != null
                    //         ? restaurantController.restaurantModel.totalSize
                    //         : null,
                    //     offset: restaurantController.restaurantModel != null
                    //         ? restaurantController.restaurantModel.offset
                    //         : null,
                    //     onPaginate: (int offset) async => await restaurantController
                    //         .getRestaurantList(offset, false),
                    //     productView: ProductView(
                    //       isRestaurant: true,
                    //       products: null,
                    //       showTheme1Restaurant: true,
                    //       restaurants: restaurantController.restaurantModel != null
                    //           ? restaurantController.restaurantModel.restaurants
                    //           : null,
                    //       padding: EdgeInsets.symmetric(
                    //         horizontal: ResponsiveHelper.isDesktop(context)
                    //             ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                    //             : Dimensions.PADDING_SIZE_SMALL,
                    //         vertical: ResponsiveHelper.isDesktop(context)
                    //             ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                    //             : 0,
                    //       ),
                    //     ),
                    //   );
                    // }),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

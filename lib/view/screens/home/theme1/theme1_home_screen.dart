import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/view/screens/home/widget/fastiry_options.dart';
import 'package:efood_multivendor/view/screens/home/widget/not_logged_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/screens/home/theme1/item_campaign_view1.dart';
import 'package:efood_multivendor/view/screens/home/theme1/popular_store_view1.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/colors.dart';
import '../../../../util/images.dart';
import '../home_screen.dart';
import 'banner_view1.dart';
import 'category_view1.dart';

class Theme1HomeScreen extends StatelessWidget {
  final ScrollController scrollController;
  const Theme1HomeScreen({@required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        // App Bar
        SliverAppBar(
          toolbarHeight: Dimensions.blockscreenVertical * 12,
          expandedHeight: Dimensions.blockscreenVertical * 16,
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
                SizedBox(
                  height: 10,
                ),
                Text(
                  "deliver_to".tr,
                  style: Get.find<FontStyles>().poppinsMedium.copyWith(
                      color: Theme.of(context).dividerColor,
                      fontSize: Dimensions.blockscreenHorizontal * 3.5),
                ),
                Row(children: [
                  InkWell(
                    onTap: () =>
                        Get.toNamed(RouteHelper.getAccessLocationRoute('home')),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_SMALL,
                        horizontal: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.PADDING_SIZE_SMALL
                            : 0,
                      ),
                      child: GetBuilder<LocationController>(
                          builder: (locationController) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  Images.pin_marker,
                                  color: Theme.of(context).primaryColor,
                                  height: Dimensions.blockscreenHorizontal * 5,
                                ),
                                SizedBox(
                                    width:
                                        Dimensions.blockscreenHorizontal * 2),
                                Container(
                                  width: Dimensions.screenWidth * 0.65,
                                  child: Text(
                                    locationController.getUserAddress().address,
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
                            Get.find<CartController>().cartList.length > 0
                                ? InkWell(
                                    onTap: () =>
                                        Get.toNamed(RouteHelper.getCartRoute()),
                                    child: Badge(
                                      showBadge: true,
                                      badgeColor:
                                          Theme.of(context).primaryColor,
                                      badgeContent: Center(
                                        child: Text(
                                          Get.find<CartController>()
                                              .cartList
                                              .length
                                              .toString(),
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        Images.cartIcon,
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        );
                      }),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),

        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              height: Dimensions.blockscreenHorizontal * 20,
              width: Dimensions.WEB_MAX_WIDTH,
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: InkWell(
                onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? offWhite : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: Get.isDarkMode
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[300],
                                spreadRadius: 0.4,
                                blurRadius: 5)
                          ],
                  ),
                  child: Row(children: [
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Icon(
                      Icons.search,
                      size: 25,
                      color: extraLightGrey,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Expanded(
                        child: Text(
                      'search_food_or_restaurant'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.find<FontStyles>().poppinsRegular.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 3.5,
                            color: extraLightGrey,
                          ),
                    )),
                  ]),
                ),
              ),
            ),
          )),
        ),

        // sections
        SliverToBoxAdapter(
          child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              !Get.find<AuthController>().isLoggedIn()
                  ? NotLoggedCard()
                  : SizedBox(),
              FastiryOptions(),
              PopularStoreView1(isPopular: false),
              BannerView1(),
              CategoryView1(),
              ItemCampaignView1(),
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
    );
  }
}

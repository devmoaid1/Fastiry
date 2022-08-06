import 'package:badges/badges.dart';
import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/view/screens/home/widget/filter_view.dart';
import 'package:efood_multivendor/view/screens/home/widget/not_logged_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:efood_multivendor/controller/location_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/paginated_list_view.dart';
import 'package:efood_multivendor/view/screens/home/home_screen.dart';
import 'package:efood_multivendor/view/screens/home/theme1/best_reviewed_item_view.dart';
import 'package:efood_multivendor/view/screens/home/theme1/category_view1.dart';
import 'package:efood_multivendor/view/screens/home/theme1/item_campaign_view1.dart';
import 'package:efood_multivendor/view/screens/home/theme1/popular_item_view1.dart';
import 'package:efood_multivendor/view/screens/home/theme1/popular_store_view1.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../util/images.dart';
import 'banner_view1.dart';

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
          toolbarHeight: Dimensions.blockscreenVertical * 10,
          expandedHeight: Dimensions.blockscreenVertical * 12,
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
                  style: poppinsRegular.copyWith(
                      color: Theme.of(context).dividerColor,
                      fontSize: Dimensions.blockscreenHorizontal * 3),
                ),
                Row(children: [
                  Expanded(
                      child: InkWell(
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              Images.pinIcon,
                              color: Theme.of(context).primaryColor,
                              height: Dimensions.blockscreenHorizontal * 5,
                            ),
                            SizedBox(
                                width: Dimensions.blockscreenHorizontal * 2),
                            Flexible(
                              child: Text(
                                locationController.getUserAddress().address,
                                style: poppinsRegular.copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).disabledColor,
                            ),
                            Get.find<CartController>().cartList.length > 0
                                ? InkWell(
                                    onTap: () =>
                                        Get.toNamed(RouteHelper.getCartRoute()),
                                    child: Badge(
                                      showBadge: true,
                                      padding: EdgeInsets.all(5),
                                      borderRadius: BorderRadius.circular(5),
                                      badgeColor:
                                          Theme.of(context).primaryColor,
                                      badgeContent: Text(
                                        Get.find<CartController>()
                                            .cartList
                                            .length
                                            .toString(),
                                        style: poppinsRegular.copyWith(
                                            color: Colors.white),
                                      ),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        );
                      }),
                    ),
                  )),
                ]),
              ],
            ),
          ),
        ),

        // Search Button
        SliverPersistentHeader(
          pinned: true,
          delegate: SliverDelegate(
              child: Container(
            height: Dimensions.blockscreenHorizontal * 20,
            width: Dimensions.WEB_MAX_WIDTH,
            color: Theme.of(context).backgroundColor,
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            child: InkWell(
              onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: offWhite,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 300],
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
                    style: poppinsRegular.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 3.5,
                      color: extraLightGrey,
                    ),
                  )),
                ]),
              ),
            ),
          )),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              !Get.find<AuthController>().isLoggedIn()
                  ? NotLoggedCard()
                  : SizedBox(),
              BannerView1(),
              CategoryView1(),
              ItemCampaignView1(),
              BestReviewedItemView(),
              PopularStoreView1(isPopular: true),
              PopularItemView1(isPopular: true),
              PopularStoreView1(isPopular: false),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.blockscreenVertical * 3,
                    horizontal: Dimensions.blockscreenHorizontal * 3),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    'all_restaurants'.tr,
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.blockscreenHorizontal * 3.5,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).dividerColor),
                  )),
                  FilterView(),
                ]),
              ),
              GetBuilder<RestaurantController>(builder: (restaurantController) {
                return PaginatedListView(
                  scrollController: scrollController,
                  totalSize: restaurantController.restaurantModel != null
                      ? restaurantController.restaurantModel.totalSize
                      : null,
                  offset: restaurantController.restaurantModel != null
                      ? restaurantController.restaurantModel.offset
                      : null,
                  onPaginate: (int offset) async => await restaurantController
                      .getRestaurantList(offset, false),
                  productView: ProductView(
                    isRestaurant: true,
                    products: null,
                    showTheme1Restaurant: true,
                    restaurants: restaurantController.restaurantModel != null
                        ? restaurantController.restaurantModel.restaurants
                        : null,
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                          : Dimensions.PADDING_SIZE_SMALL,
                      vertical: ResponsiveHelper.isDesktop(context)
                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                          : 0,
                    ),
                  ),
                );
              }),
            ]),
          ),
        ),
      ],
    );
  }
}

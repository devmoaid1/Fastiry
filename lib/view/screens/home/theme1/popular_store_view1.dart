import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/image_checker.dart';
import '../../../../util/images.dart';
import '../../../base/discount_tag.dart';

class PopularStoreView1 extends StatelessWidget {
  final bool isPopular;
  PopularStoreView1({@required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restaurantController) {
      List<Restaurant> _restaurant = isPopular
          ? restaurantController.popularRestaurantList
          : restaurantController.latestRestaurantList;

      return (_restaurant != null && _restaurant.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, isPopular ? 15 : 15, 10, 10),
                  child: TitleWidget(
                    title: isPopular
                        ? 'popular_restaurants'.tr
                        : '${'new_on'.tr} ${"fasteriy".tr}',
                    onTap: () => Get.toNamed(RouteHelper.getAllRestaurantRoute(
                        isPopular ? 'popular' : 'latest')),
                  ),
                ),
                SizedBox(
                  height: Dimensions.blockscreenVertical * 32,
                  child: _restaurant != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount:
                              _restaurant.length > 10 ? 10 : _restaurant.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: Dimensions.PADDING_SIZE_SMALL),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    RouteHelper.getRestaurantRoute(
                                        _restaurant[index].id),
                                    arguments: RestaurantScreen(
                                        restaurant: _restaurant[index]),
                                  );
                                },
                                child: Container(
                                  width: Dimensions.blockscreenHorizontal * 50,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    boxShadow: [
                                      !Get.isDarkMode
                                          ? BoxShadow(
                                              color: Colors.grey[200],
                                              spreadRadius: 0.4,
                                              blurRadius: 7)
                                          : BoxShadow(
                                              color: Theme.of(context)
                                                  .backgroundColor)
                                    ],
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(
                                                    Dimensions.RADIUS_SMALL)),
                                            child: _restaurant[index]
                                                    .coverPhoto
                                                    .isNotEmpty
                                                ? checkImage(
                                                    '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}'
                                                    '/${_restaurant[index].coverPhoto}',
                                                    Dimensions
                                                            .blockscreenHorizontal *
                                                        50,
                                                    Dimensions
                                                            .blockscreenVertical *
                                                        13,
                                                    BoxFit.fill)
                                                : Image.asset(
                                                    Images.placeholder,
                                                    fit: BoxFit.fill,
                                                    width: Dimensions
                                                            .blockscreenHorizontal *
                                                        50,
                                                    height: Dimensions
                                                            .blockscreenVertical *
                                                        13,
                                                  ),
                                          ),
                                          restaurantController
                                                  .isOpenNow(_restaurant[index])
                                              ? SizedBox()
                                              : NotAvailableWidget(
                                                  isRestaurant: true),
                                        ]),
                                        Expanded(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL,
                                                  vertical: Dimensions
                                                          .blockscreenVertical *
                                                      2),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: (Dimensions
                                                                      .blockscreenHorizontal *
                                                                  50) *
                                                              0.8,
                                                          child: Text(
                                                            _restaurant[index]
                                                                    .name ??
                                                                '',
                                                            style: Get.find<
                                                                    FontStyles>()
                                                                .poppinsMedium
                                                                .copyWith(
                                                                    fontSize:
                                                                        Dimensions.blockscreenHorizontal *
                                                                            4),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        GetBuilder<
                                                                WishListController>(
                                                            builder:
                                                                (wishController) {
                                                          bool _isWished =
                                                              wishController
                                                                  .wishRestIdList
                                                                  .contains(
                                                                      _restaurant[
                                                                              index]
                                                                          .id);
                                                          return InkWell(
                                                            onTap: () {
                                                              if (Get.find<
                                                                      AuthController>()
                                                                  .isLoggedIn()) {
                                                                _isWished
                                                                    ? wishController.removeFromWishList(
                                                                        _restaurant[index]
                                                                            .id,
                                                                        true)
                                                                    : wishController.addToWishList(
                                                                        null,
                                                                        _restaurant[
                                                                            index],
                                                                        true);
                                                              } else {
                                                                showCustomSnackBar(
                                                                    'you_are_not_logged_in'
                                                                        .tr);
                                                              }
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .all(Dimensions
                                                                      .PADDING_SIZE_EXTRA_SMALL),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        Dimensions
                                                                            .RADIUS_SMALL),
                                                              ),
                                                              child: Icon(
                                                                _isWished
                                                                    ? Icons
                                                                        .favorite
                                                                    : Icons
                                                                        .favorite_border,
                                                                size: 17,
                                                                color: _isWished
                                                                    ? Theme.of(
                                                                            context)
                                                                        .primaryColor
                                                                    : Theme.of(
                                                                            context)
                                                                        .disabledColor,
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                    Text(
                                                      _restaurant[index]
                                                              .address ??
                                                          '',
                                                      style: Get.find<
                                                              FontStyles>()
                                                          .poppinsMedium
                                                          .copyWith(
                                                              fontSize: Dimensions
                                                                      .blockscreenHorizontal *
                                                                  3,
                                                              color: Theme.of(
                                                                      context)
                                                                  .dividerColor
                                                                  .withOpacity(
                                                                      0.6)),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                      height: Dimensions
                                                          .blockscreenVertical,
                                                    ),
                                                    RatingBar(
                                                      rating: _restaurant[index]
                                                          .avgRating,
                                                      ratingCount:
                                                          _restaurant[index]
                                                              .ratingCount,
                                                      size: 13,
                                                    ),
                                                    SizedBox(
                                                      height: Dimensions
                                                          .blockscreenVertical,
                                                    ),
                                                    _restaurant[index]
                                                                .discount !=
                                                            null
                                                        ? DiscountTag(
                                                            discount:
                                                                _restaurant[
                                                                        index]
                                                                    .discount
                                                                    .discount,
                                                            discountType:
                                                                _restaurant[
                                                                        index]
                                                                    .discount
                                                                    .discountType,
                                                          )
                                                        : SizedBox()
                                                  ])),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          },
                        )
                      : PopularStoreShimmer(
                          restaurantController: restaurantController),
                ),
              ],
            );
    });
  }
}

class PopularStoreShimmer extends StatelessWidget {
  final RestaurantController restaurantController;
  PopularStoreShimmer({@required this.restaurantController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: Dimensions.blockscreenVertical * 12,
          width: Dimensions.blockscreenHorizontal * 45,
          margin:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: Get.isDarkMode
                  ? null
                  : [
                      BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 10,
                          spreadRadius: 1)
                    ]),
          child: Shimmer(
            enabled: Get.find<HomeController>().isLoading &&
                restaurantController.restaurantList == null,
            duration: Duration(seconds: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[300]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 10, width: 100, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        Container(
                            height: 10, width: 130, color: Colors.grey[300]),
                        SizedBox(height: 5),
                        RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}

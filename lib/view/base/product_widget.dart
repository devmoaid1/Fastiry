import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/data/model/response/config_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/product_details/productDetails.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../../helper/price_converter.dart';
import '../../theme/font_styles.dart';
import 'discount_tag.dart';
import 'discount_tag_without_image.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final Restaurant restaurant;
  final bool isRestaurant;
  final int index;
  final int length;
  final bool inRestaurant;
  final bool isCampaign;
  ProductWidget(
      {@required this.product,
      @required this.isRestaurant,
      @required this.restaurant,
      @required this.index,
      @required this.length,
      this.inRestaurant = false,
      this.isCampaign = false});

  @override
  Widget build(BuildContext context) {
    BaseUrls _baseUrls = Get.find<SplashController>().configModel.baseUrls;
    double _discount;
    String _discountType;
    bool _isAvailable;
    String _image;
    bool _desktop = ResponsiveHelper.isDesktop(context);
    if (isRestaurant) {
      _image = restaurant.logo;
      _discount =
          restaurant.discount != null ? restaurant.discount.discount : 0;
      _discountType = restaurant.discount != null
          ? restaurant.discount.discountType
          : 'percent';
      // bool _isClosedToday = Get.find<RestaurantController>().isRestaurantClosed(true, restaurant.active, restaurant.offDay);
      // _isAvailable = DateConverter.isAvailable(restaurant.openingTime, restaurant.closeingTime) && restaurant.active && !_isClosedToday;
      _isAvailable = restaurant.open == 1 && restaurant.active;
    } else {
      _image = product.image;
      _discount = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discount
          : product.restaurantDiscount;
      _discountType = (product.restaurantDiscount == 0 || isCampaign)
          ? product.discountType
          : 'percent';
      _isAvailable = DateConverter.isAvailable(
          product.availableTimeStarts, product.availableTimeEnds);
    }

    Widget _buildRestaurantView(BuildContext context) {
      return !inRestaurant
          ? Dismissible(
              key: ObjectKey(restaurant),
              background: Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      Text('remove from wishlist',
                          style: Get.find<FontStyles>()
                              .poppinsRegular
                              .copyWith(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              onDismissed: (dismiss) {
                Get.find<WishListController>()
                    .removeFromWishList(restaurant.id, isRestaurant);
              },
              child: InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
                      arguments: RestaurantScreen(restaurant: restaurant));
                },
                child: Container(
                  padding: ResponsiveHelper.isDesktop(context)
                      ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                      : null,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: ResponsiveHelper.isDesktop(context)
                        ? Theme.of(context).cardColor
                        : null,
                    boxShadow: ResponsiveHelper.isDesktop(context)
                        ? [
                            Get.isDarkMode
                                ? BoxShadow(
                                    color: Colors.grey[300],
                                    spreadRadius: 0.4,
                                    blurRadius: 7,
                                  )
                                : BoxShadow(
                                    color: Theme.of(context).backgroundColor)
                          ]
                        : null,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: _desktop
                                  ? 0
                                  : Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (_image != null && _image.isNotEmpty)
                                    ? Stack(children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          child: CustomImage(
                                            image:
                                                '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                                '/${isRestaurant ? restaurant.logo : product.image}',
                                            height: _desktop
                                                ? 120
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    32,
                                            width: _desktop
                                                ? 120
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    32,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        _isAvailable
                                            ? SizedBox()
                                            : NotAvailableWidget(
                                                isRestaurant: isRestaurant),
                                      ])
                                    : SizedBox.shrink(),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant.name,
                                          style: Get.find<FontStyles>()
                                              .poppinsMedium
                                              .copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    5.5,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    2),
                                        Text(restaurant.address,
                                            style: Get.find<FontStyles>()
                                                .poppinsRegular
                                                .copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      3.5,
                                                )),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    0.5),
                                        RatingBar(
                                            rating: restaurant.avgRating,
                                            size: _desktop ? 15 : 12,
                                            ratingCount:
                                                restaurant.ratingCount),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Images.clockIcon,
                                              color: Theme.of(context)
                                                  .dividerColor,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: Dimensions
                                                      .blockscreenHorizontal *
                                                  20,
                                              child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Text(
                                                    "in ${restaurant.deliveryTime} mins",
                                                    style: Get.find<
                                                            FontStyles>()
                                                        .poppinsRegular
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor),
                                                  )),
                                            )
                                          ],
                                        ),
                                        DiscountTag(
                                          discount: _discount,
                                          discountType: _discountType,
                                        )
                                      ]),
                                ),
                              ]),
                        ),
                        _desktop
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.only(
                                    left: _desktop
                                        ? 130
                                        : Dimensions.screenWidth -
                                            Dimensions.blockscreenHorizontal *
                                                67),
                                child: Divider(
                                    color: index == length - 1
                                        ? Colors.transparent
                                        : Theme.of(context).disabledColor),
                              ),
                      ]),
                ),
              ),
            )
          : InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.getRestaurantRoute(restaurant.id),
                    arguments: RestaurantScreen(restaurant: restaurant));
              },
              child: Container(
                padding: ResponsiveHelper.isDesktop(context)
                    ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                    : null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: ResponsiveHelper.isDesktop(context)
                      ? Theme.of(context).cardColor
                      : null,
                  boxShadow: ResponsiveHelper.isDesktop(context)
                      ? [
                          Get.isDarkMode
                              ? BoxShadow(
                                  color: Colors.grey[300],
                                  spreadRadius: 0.4,
                                  blurRadius: 7,
                                )
                              : BoxShadow(
                                  color: Theme.of(context).backgroundColor)
                        ]
                      : null,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _desktop
                                ? 0
                                : Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (_image != null && _image.isNotEmpty)
                                  ? Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        child: CustomImage(
                                          image:
                                              '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                              '/${isRestaurant ? restaurant.logo : product.image}',
                                          height: _desktop
                                              ? 120
                                              : Dimensions
                                                      .blockscreenHorizontal *
                                                  32,
                                          width: _desktop
                                              ? 120
                                              : Dimensions
                                                      .blockscreenHorizontal *
                                                  32,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      _isAvailable
                                          ? SizedBox()
                                          : NotAvailableWidget(
                                              isRestaurant: isRestaurant),
                                    ])
                                  : SizedBox.shrink(),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.name ?? "",
                                        style: Get.find<FontStyles>()
                                            .poppinsMedium
                                            .copyWith(
                                              fontSize: Dimensions
                                                      .blockscreenHorizontal *
                                                  5.5,
                                            ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.blockscreenVertical *
                                                  2),
                                      Text(restaurant.address ?? "",
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    3.5,
                                              )),
                                      SizedBox(
                                          height:
                                              Dimensions.blockscreenVertical *
                                                  0.5),
                                      RatingBar(
                                          rating: restaurant.avgRating,
                                          size: _desktop ? 15 : 12,
                                          ratingCount: restaurant.ratingCount),
                                      SizedBox(
                                          height:
                                              Dimensions.blockscreenVertical),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            Images.clockIcon,
                                            width: Dimensions
                                                    .blockscreenHorizontal *
                                                4.5,
                                            height: Dimensions
                                                    .blockscreenHorizontal *
                                                4.5,
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: Dimensions
                                                    .blockscreenHorizontal *
                                                20,
                                            child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "${restaurant.deliveryTime} ${"min".tr}",
                                                  style: Get.find<FontStyles>()
                                                      .poppinsRegular
                                                      .copyWith(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor),
                                                )),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.blockscreenVertical),
                                      DiscountTag(
                                        discount: _discount,
                                        discountType: _discountType,
                                      )
                                    ]),
                              ),
                            ]),
                      ),
                      _desktop
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(
                                  left: _desktop
                                      ? 130
                                      : Dimensions.screenWidth -
                                          Dimensions.blockscreenHorizontal *
                                              67),
                              child: Divider(
                                  color: index == length - 1
                                      ? Colors.transparent
                                      : Theme.of(context).disabledColor),
                            ),
                    ]),
              ),
            );
    }

    Widget _buildProductView(context) {
      return GetBuilder<CartController>(
        builder: (cartController) {
          final isExistInCart = cartController.isProductExistInCart(product.id);
          int index = -1;
          if (isExistInCart) {
            index = cartController.cartList
                .indexWhere((cartItem) => cartItem.product.id == product.id);
          }

          return !inRestaurant
              ? Dismissible(
                  key: ObjectKey(product),
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          Text('remove_wishlist'.tr,
                              style: Get.find<FontStyles>()
                                  .poppinsRegular
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  onDismissed: (dismissDirection) {
                    Get.find<WishListController>()
                        .removeFromWishList(product.id, isRestaurant);
                  },
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(
                          RouteHelper.getProductDetailsRoute(product.id),
                          arguments: ProductDetailsScreen(product: product));
                    },
                    child: Container(
                      padding: ResponsiveHelper.isDesktop(context)
                          ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                          : null,
                      decoration: BoxDecoration(
                        color: ResponsiveHelper.isDesktop(context)
                            ? Theme.of(context).cardColor
                            : null,
                        boxShadow: ResponsiveHelper.isDesktop(context)
                            ? [
                                Get.isDarkMode
                                    ? BoxShadow(
                                        color: Colors.grey[300],
                                        spreadRadius: 0.4,
                                        blurRadius: 7,
                                      )
                                    : BoxShadow(
                                        color:
                                            Theme.of(context).backgroundColor)
                              ]
                            : null,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (_image != null && _image.isNotEmpty)
                                      ? Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            child: CustomImage(
                                              image:
                                                  '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                                  '/${isRestaurant ? restaurant.logo : product.image}',
                                              height: _desktop
                                                  ? 120
                                                  : Dimensions
                                                          .blockscreenHorizontal *
                                                      30,
                                              width: _desktop
                                                  ? 120
                                                  : Dimensions
                                                          .blockscreenHorizontal *
                                                      30,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          _isAvailable
                                              ? SizedBox()
                                              : NotAvailableWidget(
                                                  isRestaurant: isRestaurant),
                                        ])
                                      : SizedBox.shrink(),
                                  SizedBox(
                                      width:
                                          Dimensions.blockscreenHorizontal * 3),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                product.name,
                                                style: Get.find<FontStyles>()
                                                    .poppinsMedium
                                                    .copyWith(
                                                      fontSize: Dimensions
                                                              .blockscreenHorizontal *
                                                          5.5,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              isExistInCart
                                                  ? Text(
                                                      "${cartController.cartList[index].quantity}",
                                                      style:
                                                          Get.find<FontStyles>()
                                                              .poppinsMedium
                                                              .copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: Dimensions
                                                                        .blockscreenHorizontal *
                                                                    4,
                                                              ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  : SizedBox(),
                                            ],
                                          ),
                                          SizedBox(
                                              height: product.discount > 0
                                                  ? 4
                                                  : Dimensions
                                                          .blockscreenVertical *
                                                      2),
                                          Text(
                                            product.description,
                                            style: Get.find<FontStyles>()
                                                .poppinsRegular
                                                .copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      3.5,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                      .blockscreenVertical *
                                                  0.4),
                                          RatingBar(
                                            rating: product.avgRating,
                                            size: _desktop ? 15 : 12,
                                            ratingCount: product.ratingCount,
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                      .blockscreenVertical *
                                                  0.4),
                                          Row(children: [
                                            Text(
                                              PriceConverter.convertPrice(
                                                  product.price,
                                                  discount: _discount,
                                                  discountType: _discountType),
                                              style: Get.find<FontStyles>()
                                                  .poppinsMedium
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .dividerColor,
                                                      fontSize: Dimensions
                                                              .blockscreenHorizontal *
                                                          4),
                                            ),
                                            SizedBox(
                                                width: _discount > 0
                                                    ? Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL
                                                    : 0),
                                            _discount > 0
                                                ? Text(
                                                    PriceConverter.convertPrice(
                                                        product.price),
                                                    style:
                                                        Get.find<FontStyles>()
                                                            .poppinsRegular
                                                            .copyWith(
                                                              fontSize: Dimensions
                                                                      .blockscreenHorizontal *
                                                                  3.2,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                              decorationThickness:
                                                                  4,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                  )
                                                : SizedBox(),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            (_image != null &&
                                                    _image.isNotEmpty)
                                                ? SizedBox.shrink()
                                                : DiscountTagWithoutImage(
                                                    discount: _discount,
                                                    discountType: _discountType,
                                                    freeDelivery: isRestaurant
                                                        ? restaurant
                                                            .freeDelivery
                                                        : false),
                                          ]),
                                          SizedBox(
                                              height: Dimensions
                                                  .blockscreenVertical),
                                          DiscountTag(
                                            discount: _discount,
                                            discountType: _discountType,
                                          )
                                        ]),
                                  ),
                                  isExistInCart
                                      ? Container(
                                          height: 50,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadiusDirectional.only(
                                                      topStart:
                                                          Radius.circular(8),
                                                      bottomStart:
                                                          Radius.circular(8)),
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      : SizedBox()
                                ]),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: _desktop
                                      ? 130
                                      : Dimensions.screenWidth -
                                          Dimensions.blockscreenHorizontal *
                                              65),
                              child: Divider(
                                  color: index == length - 1
                                      ? Colors.transparent
                                      : Theme.of(context).disabledColor),
                            ),
                          ]),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    Get.toNamed(RouteHelper.getProductDetailsRoute(product.id),
                        arguments: ProductDetailsScreen(product: product));
                  },
                  child: Container(
                    padding: ResponsiveHelper.isDesktop(context)
                        ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL)
                        : null,
                    decoration: BoxDecoration(
                      color: ResponsiveHelper.isDesktop(context)
                          ? Theme.of(context).cardColor
                          : null,
                      boxShadow: ResponsiveHelper.isDesktop(context)
                          ? [
                              Get.isDarkMode
                                  ? BoxShadow(
                                      color: Colors.grey[300],
                                      spreadRadius: 0.4,
                                      blurRadius: 7,
                                    )
                                  : BoxShadow(
                                      color: Theme.of(context).backgroundColor)
                            ]
                          : null,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (_image != null && _image.isNotEmpty)
                                    ? Stack(children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          child: CustomImage(
                                            image:
                                                '${isCampaign ? _baseUrls.campaignImageUrl : isRestaurant ? _baseUrls.restaurantImageUrl : _baseUrls.productImageUrl}'
                                                '/${isRestaurant ? restaurant.logo : product.image}',
                                            height: _desktop
                                                ? 120
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    30,
                                            width: _desktop
                                                ? 120
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    30,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        _isAvailable
                                            ? SizedBox()
                                            : NotAvailableWidget(
                                                isRestaurant: isRestaurant),
                                      ])
                                    : SizedBox.shrink(),
                                SizedBox(
                                    width:
                                        Dimensions.blockscreenHorizontal * 3),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                                  Dimensions.screenWidth * 0.50,
                                              child: Text(
                                                product.name,
                                                style: Get.find<FontStyles>()
                                                    .poppinsMedium
                                                    .copyWith(
                                                      fontSize: Dimensions
                                                              .blockscreenHorizontal *
                                                          5,
                                                    ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions
                                                      .blockscreenHorizontal *
                                                  2,
                                            ),
                                            isExistInCart
                                                ? Text(
                                                    "x ${cartController.cartList[index].quantity}",
                                                    style:
                                                        Get.find<FontStyles>()
                                                            .poppinsMedium
                                                            .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: Dimensions
                                                                      .blockscreenHorizontal *
                                                                  4,
                                                            ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                        SizedBox(
                                            height: product.discount > 0
                                                ? 4
                                                : Dimensions
                                                        .blockscreenVertical *
                                                    3),
                                        Text(
                                          product.description,
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      3.5,
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    0.4),
                                        RatingBar(
                                          rating: product.avgRating,
                                          size: _desktop ? 15 : 12,
                                          ratingCount: product.ratingCount,
                                        ),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical *
                                                    0.4),
                                        Row(children: [
                                          Text(
                                            PriceConverter.convertPrice(
                                                product.price,
                                                discount: _discount,
                                                discountType: _discountType),
                                            style: Get.find<FontStyles>()
                                                .poppinsMedium
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .dividerColor,
                                                    fontSize: Dimensions
                                                            .blockscreenHorizontal *
                                                        4),
                                          ),
                                          SizedBox(
                                              width: _discount > 0
                                                  ? Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL
                                                  : 0),
                                          _discount > 0
                                              ? Text(
                                                  PriceConverter.convertPrice(
                                                      product.price),
                                                  style: Get.find<FontStyles>()
                                                      .poppinsRegular
                                                      .copyWith(
                                                        fontSize: Dimensions
                                                                .blockscreenHorizontal *
                                                            3.2,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                        decorationThickness: 4,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      ),
                                                )
                                              : SizedBox(),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          (_image != null && _image.isNotEmpty)
                                              ? SizedBox.shrink()
                                              : DiscountTagWithoutImage(
                                                  discount: _discount,
                                                  discountType: _discountType,
                                                  freeDelivery: isRestaurant
                                                      ? restaurant.freeDelivery
                                                      : false),
                                        ]),
                                        SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical),
                                        DiscountTag(
                                          discount: _discount,
                                          discountType: _discountType,
                                        )
                                      ]),
                                ),
                                isExistInCart
                                    ? Container(
                                        height: 50,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                                    topStart:
                                                        Radius.circular(8),
                                                    bottomStart:
                                                        Radius.circular(8)),
                                            color:
                                                Theme.of(context).primaryColor),
                                      )
                                    : SizedBox()
                              ]),
                          Padding(
                            padding: EdgeInsets.only(
                                left: _desktop
                                    ? 130
                                    : Dimensions.screenWidth -
                                        Dimensions.blockscreenHorizontal * 65),
                            child: Divider(
                                color: index == length - 1
                                    ? Colors.transparent
                                    : Theme.of(context).disabledColor),
                          ),
                        ]),
                  ),
                );
        },
      );
    }

    if (isRestaurant) {
      return _buildRestaurantView(context);
    }

    return _buildProductView(context);
  }
}

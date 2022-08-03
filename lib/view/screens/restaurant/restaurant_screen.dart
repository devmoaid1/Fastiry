import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/controller/localization_controller.dart';
import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/product_view.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantScreen extends StatefulWidget {
  final Restaurant restaurant;
  RestaurantScreen({@required this.restaurant});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;

  @override
  void initState() {
    super.initState();

    Get.find<RestaurantController>()
        .getRestaurantDetails(Restaurant(id: widget.restaurant.id));
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<RestaurantController>()
        .getRestaurantProductList(widget.restaurant.id, 1, 'all', false);
    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<RestaurantController>().restaurantProducts != null &&
          !Get.find<RestaurantController>().foodPaginate) {
        int pageSize =
            (Get.find<RestaurantController>().foodPageSize / 10).ceil();
        if (Get.find<RestaurantController>().foodOffset < pageSize) {
          Get.find<RestaurantController>()
              .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
          print('end of the page');
          Get.find<RestaurantController>().showFoodBottomLoader();
          Get.find<RestaurantController>().getRestaurantProductList(
            widget.restaurant.id,
            Get.find<RestaurantController>().foodOffset,
            Get.find<RestaurantController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          Restaurant _restaurant;
          if (restController.restaurant != null &&
              restController.restaurant.name != null &&
              categoryController.categoryList != null) {
            _restaurant = restController.restaurant;
          }
          restController.setCategoryList();

          bool isAvailable = restController.isRestaurantOpenNow(
              restController.restaurant.active,
              restController.restaurant.schedules);

          return (restController.restaurant != null &&
                  restController.restaurant.name != null &&
                  categoryController.categoryList != null)
              ? CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  slivers: [
                    ResponsiveHelper.isDesktop(context)
                        ? SliverToBoxAdapter(
                            child: Container(
                              color: Color(0xFF171A29),
                              padding:
                                  EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                              alignment: Alignment.center,
                              child: Center(
                                  child: SizedBox(
                                      width: Dimensions.WEB_MAX_WIDTH,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        child: Row(children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              child: CustomImage(
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    Images.restaurant_cover,
                                                height: 220,
                                                image:
                                                    '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          Expanded(
                                              child: RestaurantDescriptionView(
                                                  restaurant: _restaurant)),
                                        ]),
                                      ))),
                            ),
                          )
                        : SliverAppBar(
                            expandedHeight: Dimensions.blockscreenVertical * 25,
                            toolbarHeight: 50,
                            pinned: true,
                            floating: false,
                            backgroundColor: Theme.of(context).backgroundColor,
                            leading: IconButton(
                              icon: Container(
                                height: Dimensions.blockscreenHorizontal * 10,
                                width: Dimensions.blockscreenHorizontal * 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Get.isDarkMode
                                        ? Theme.of(context).backgroundColor
                                        : Colors.grey[200]),
                                alignment: Alignment.center,
                                child: Icon(Icons.chevron_left,
                                    color: Theme.of(context).dividerColor),
                              ),
                              onPressed: () => Get.back(),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Stack(children: [
                                CustomImage(
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  placeholder: Images.restaurant_cover,
                                  height: Dimensions.blockscreenVertical * 25,
                                  image:
                                      '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${_restaurant.coverPhoto}',
                                ),
                                isAvailable
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          child: Text(
                                            'closed_now'.tr,
                                            textAlign: TextAlign.center,
                                            style: poppinsBold.copyWith(
                                                color: Colors.white,
                                                fontSize:
                                                    Dimensions.fontSizeSmall),
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    child: Stack(children: [
                                      CustomImage(
                                        image:
                                            '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${_restaurant.logo}',
                                        height:
                                            ResponsiveHelper.isDesktop(context)
                                                ? 80
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    15,
                                        width:
                                            ResponsiveHelper.isDesktop(context)
                                                ? 100
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    17,
                                        fit: BoxFit.fill,
                                      ),
                                    ]),
                                  ),
                                ),
                              ]),
                            ),
                            actions: [
                              IconButton(
                                onPressed: () => Get.toNamed(
                                    RouteHelper.getSearchRestaurantProductRoute(
                                        _restaurant.id)),
                                icon: Container(
                                  height: Dimensions.blockscreenHorizontal * 10,
                                  width: Dimensions.blockscreenHorizontal * 10,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Get.isDarkMode
                                          ? Theme.of(context).backgroundColor
                                          : Colors.grey[200]),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.search,
                                      color: Theme.of(context).dividerColor),
                                ),
                              )
                            ],
                          ),
                    SliverToBoxAdapter(
                        child: Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      color: Theme.of(context).backgroundColor,
                      child: Column(children: [
                        ResponsiveHelper.isDesktop(context)
                            ? SizedBox()
                            : RestaurantDescriptionView(
                                restaurant: _restaurant),
                        _restaurant.discount != null
                            ? Container(
                                width: context.width,
                                margin: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    color: Theme.of(context).primaryColor),
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _restaurant.discount.discountType ==
                                                'percent'
                                            ? '${_restaurant.discount.discount}% OFF'
                                            : '${PriceConverter.convertPrice(_restaurant.discount.discount)} OFF',
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge,
                                            color: Theme.of(context).cardColor),
                                      ),
                                      Text(
                                        _restaurant.discount.discountType ==
                                                'percent'
                                            ? '${'enjoy'.tr} ${_restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                            : '${'enjoy'.tr} ${PriceConverter.convertPrice(_restaurant.discount.discount)}'
                                                ' ${'off_on_all_categories'.tr}',
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeSmall,
                                            color: Theme.of(context).cardColor),
                                      ),
                                      SizedBox(
                                          height: (_restaurant.discount
                                                          .minPurchase !=
                                                      0 ||
                                                  _restaurant.discount
                                                          .maxDiscount !=
                                                      0)
                                              ? 5
                                              : 0),
                                      _restaurant.discount.minPurchase != 0
                                          ? Text(
                                              '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.minPurchase)} ]',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            )
                                          : SizedBox(),
                                      _restaurant.discount.maxDiscount != 0
                                          ? Text(
                                              '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(_restaurant.discount.maxDiscount)} ]',
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Theme.of(context)
                                                      .cardColor),
                                            )
                                          : SizedBox(),
                                      Text(
                                        '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(_restaurant.discount.startTime)} '
                                        '- ${DateConverter.convertTimeToTime(_restaurant.discount.endTime)} ]',
                                        style: robotoRegular.copyWith(
                                            fontSize:
                                                Dimensions.fontSizeExtraSmall,
                                            color: Theme.of(context).cardColor),
                                      ),
                                    ]),
                              )
                            : SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Divider(
                            height: 20,
                            thickness: 3,
                            color: Get.isDarkMode
                                ? Theme.of(context)
                                    .disabledColor
                                    .withOpacity(0.5)
                                : Colors.grey[300],
                          ),
                        )
                      ]),
                    )),
                    (restController.categoryList.length > 0)
                        ? SliverPersistentHeader(
                            pinned: true,
                            delegate: SliverDelegate(
                                child: Container(
                              height: 80,
                              width: Dimensions.WEB_MAX_WIDTH,
                              color: Theme.of(context).backgroundColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: Dimensions.blockscreenVertical,
                                  horizontal: 10),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: restController.categoryList.length,
                                padding: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_SMALL),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () =>
                                        restController.setCategoryIndex(index),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 10),
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.blockscreenVertical,
                                          horizontal:
                                              Dimensions.blockscreenHorizontal),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: index ==
                                                          restController
                                                              .categoryIndex
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .backgroundColor,
                                                  width: 2))),
                                      child: Text(
                                        restController.categoryList[index].name,
                                        style: index ==
                                                restController.categoryIndex
                                            ? poppinsMedium.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .primaryColor)
                                            : poppinsRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .disabledColor),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                          )
                        : SliverToBoxAdapter(child: SizedBox()),
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.blockscreenVertical * 2),
                      child: Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                        ),
                        child: Column(children: [
                          ProductView(
                            isRestaurant: false,
                            restaurants: null,
                            products: restController.categoryList.length > 0
                                ? restController.restaurantProducts
                                : null,
                            inRestaurantPage: true,
                            type: restController.type,
                            onVegFilterTap: (String type) {
                              restController.getRestaurantProductList(
                                  restController.restaurant.id, 1, type, true);
                            },
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL,
                              vertical: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.PADDING_SIZE_SMALL
                                  : 0,
                            ),
                          ),
                          restController.foodPaginate
                              ? Center(
                                  child: Padding(
                                  padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_SMALL),
                                  child: CircularProgressIndicator(),
                                ))
                              : SizedBox(),
                        ]),
                      ),
                    )),
                  ],
                )
              : Center(child: CircularProgressIndicator());
        });
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.blockscreenVertical * 2,
            horizontal: Dimensions.blockscreenHorizontal * 3),
        decoration:
            BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
          Get.isDarkMode
              ? BoxShadow(
                  blurRadius: 7, spreadRadius: 0.4, color: Colors.grey[300])
              : BoxShadow()
        ]),
        child: InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.blockscreenVertical * 2,
                horizontal: Dimensions.blockscreenHorizontal * 2),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "1",
                  style: poppinsRegular.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "View Bascket",
                      style: poppinsRegular.copyWith(color: Colors.white),
                    ),
                    Text(
                      " EGP 38.00 ",
                      style: poppinsRegular.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

class CategoryProduct {
  CategoryModel category;
  List<Product> products;
  CategoryProduct(this.category, this.products);
}

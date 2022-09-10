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
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_viewModel.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/categories_selection.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_bottom._bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_description_view.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

// class RestaurantScreen extends StatefulWidget {
//   final Restaurant restaurant;
//   RestaurantScreen({@required this.restaurant});

//   @override
//   State<RestaurantScreen> createState() => _RestaurantScreenState();
// }

// class _RestaurantScreenState extends State<RestaurantScreen> {
//   final ScrollController scrollController = ScrollController();
//   final restaurantController = Get.find<RestaurantController>();
//   final categoryController = Get.find<CategoryController>();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Get.find<RestuarantViewModel>().initRestaurantData(widget.restaurant);
//       // restaurantController
//       //     .getRestaurantDetails(Restaurant(id: widget.restaurant.id));
//       // if (categoryController.categoryList == null) {
//       //   categoryController.getCategoryList(true);
//       // }
//       // restaurantController.getRestaurantProductList(
//       //     widget.restaurant.id, 1, 'all', false);

//       Get.find<CartController>().getCartSubTotal();
//     });

//     // scrollController?.addListener(() {
//     //   if (scrollController.position.pixels ==
//     //           scrollController.position.maxScrollExtent &&
//     //       restaurantController.restaurantProducts != null &&
//     //       !Get.find<RestaurantController>().foodPaginate) {
//     //     int pageSize =
//     //         (Get.find<RestaurantController>().foodPageSize / 10).ceil();
//     //     if (Get.find<RestaurantController>().foodOffset < pageSize) {
//     //       restaurantController
//     //           .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
//     //       print('end of the page');
//     //       restaurantController.showFoodBottomLoader();
//     //       restaurantController.getRestaurantProductList(
//     //         widget.restaurant.id,
//     //         restaurantController.foodOffset,
//     //         restaurantController.type,
//     //         false,
//     //       );
//     //     }
//     //   }
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     scrollController?.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
//         backgroundColor: Theme.of(context).backgroundColor,
//         body: GetBuilder<RestuarantViewModel>(
//             init: Get.find<RestuarantViewModel>(),
//             initState: (state) =>
//                 state.controller.initRestaurantData(widget.restaurant),
//             builder: (restaurantViewModel) {
//               if (restaurantViewModel.isLoading &&
//                   restaurantViewModel.categoryProducts == null &&
//                   restaurantViewModel.restaurantAllProducts == null &&
//                   restaurantViewModel.restaurantCategories == null) {
//                 return Center(
//                   child: CustomLoader(),
//                 );
//               } else {
//                 return CustomScrollView(
//                   physics: AlwaysScrollableScrollPhysics(),
//                   controller: scrollController,
//                   slivers: [
//                     ResponsiveHelper.isDesktop(context)
//                         ? SliverToBoxAdapter(
//                             child: Container(
//                               color: Color(0xFF171A29),
//                               padding:
//                                   EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
//                               alignment: Alignment.center,
//                               child: Center(
//                                   child: SizedBox(
//                                       width: Dimensions.WEB_MAX_WIDTH,
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal:
//                                                 Dimensions.PADDING_SIZE_SMALL),
//                                         child: Row(children: [
//                                           Expanded(
//                                             child: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       Dimensions.RADIUS_SMALL),
//                                               child: CustomImage(
//                                                 fit: BoxFit.cover,
//                                                 placeholder:
//                                                     Images.restaurant_cover,
//                                                 height: 220,
//                                                 image:
//                                                     '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${widget.restaurant.coverPhoto}',
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                               width: Dimensions
//                                                   .PADDING_SIZE_LARGE),
//                                           Expanded(
//                                               child: RestaurantDescriptionView(
//                                                   restaurant:
//                                                       widget.restaurant)),
//                                         ]),
//                                       ))),
//                             ),
//                           )
//                         : SliverAppBar(
//                             expandedHeight: Dimensions.blockscreenVertical * 25,
//                             toolbarHeight: 50,
//                             pinned: true,
//                             floating: false,
//                             backgroundColor: Theme.of(context).backgroundColor,
//                             leading: IconButton(
//                               icon: Container(
//                                 height: Dimensions.blockscreenHorizontal * 12,
//                                 width: Dimensions.blockscreenHorizontal * 12,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Get.isDarkMode
//                                         ? Theme.of(context).backgroundColor
//                                         : Colors.grey[200]),
//                                 alignment: Alignment.center,
//                                 child: Icon(Icons.chevron_left,
//                                     size: 30,
//                                     color: Theme.of(context).dividerColor),
//                               ),
//                               onPressed: () => Get.back(),
//                             ),
//                             flexibleSpace: FlexibleSpaceBar(
//                                 background: RestaurantImage(
//                               restaurant: widget.restaurant,
//                               restaurantController: restaurantController,
//                             )),
//                             actions: [
//                               IconButton(
//                                 onPressed: () => Get.toNamed(
//                                     RouteHelper.getSearchRestaurantProductRoute(
//                                         widget.restaurant.id)),
//                                 icon: Container(
//                                   height: Dimensions.blockscreenHorizontal * 12,
//                                   width: Dimensions.blockscreenHorizontal * 12,
//                                   decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Get.isDarkMode
//                                           ? Theme.of(context).backgroundColor
//                                           : Colors.grey[200]),
//                                   alignment: Alignment.center,
//                                   child: Icon(Icons.search,
//                                       size: 30,
//                                       color: Theme.of(context).dividerColor),
//                                 ),
//                               )
//                             ],
//                           ),

//                     // products
//                     SliverToBoxAdapter(
//                         child: Container(
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).backgroundColor,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       width: Dimensions.WEB_MAX_WIDTH,
//                       padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//                       child: Column(children: [
//                         ResponsiveHelper.isDesktop(context)
//                             ? SizedBox()

//                             // restaurant description
//                             : RestaurantDescriptionView(
//                                 restaurant: widget.restaurant),
//                         widget.restaurant.discount != null
//                             ? Container(
//                                 width: context.width,
//                                 margin: EdgeInsets.symmetric(
//                                     vertical: Dimensions.PADDING_SIZE_SMALL),
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(
//                                         Dimensions.RADIUS_SMALL),
//                                     color: Theme.of(context).primaryColor),
//                                 padding: EdgeInsets.all(
//                                     Dimensions.PADDING_SIZE_SMALL),
//                                 child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                         widget.restaurant.discount
//                                                     .discountType ==
//                                                 'percent'
//                                             ? '${widget.restaurant.discount.discount}% OFF'
//                                             : '${PriceConverter.convertPrice(widget.restaurant.discount.discount)} OFF',
//                                         style: Get.find<FontStyles>()
//                                             .poppinsMedium
//                                             .copyWith(
//                                                 fontSize:
//                                                     Dimensions.fontSizeLarge,
//                                                 color: Theme.of(context)
//                                                     .cardColor),
//                                       ),
//                                       Text(
//                                         widget.restaurant.discount
//                                                     .discountType ==
//                                                 'percent'
//                                             ? '${'enjoy'.tr} ${widget.restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
//                                             : '${'enjoy'.tr} ${PriceConverter.convertPrice(widget.restaurant.discount.discount)}'
//                                                 ' ${'off_on_all_categories'.tr}',
//                                         style: Get.find<FontStyles>()
//                                             .poppinsMedium
//                                             .copyWith(
//                                                 fontSize:
//                                                     Dimensions.fontSizeSmall,
//                                                 color: Theme.of(context)
//                                                     .cardColor),
//                                       ),
//                                       SizedBox(
//                                           height: (widget.restaurant.discount
//                                                           .minPurchase !=
//                                                       0 ||
//                                                   widget.restaurant.discount
//                                                           .maxDiscount !=
//                                                       0)
//                                               ? 5
//                                               : 0),
//                                       widget.restaurant.discount.minPurchase !=
//                                               0
//                                           ? Text(
//                                               '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(widget.restaurant.discount.minPurchase)} ]',
//                                               style: Get.find<FontStyles>()
//                                                   .poppinsRegular
//                                                   .copyWith(
//                                                       fontSize: Dimensions
//                                                           .fontSizeExtraSmall,
//                                                       color: Theme.of(context)
//                                                           .cardColor),
//                                             )
//                                           : SizedBox(),
//                                       widget.restaurant.discount.maxDiscount !=
//                                               0
//                                           ? Text(
//                                               '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(widget.restaurant.discount.maxDiscount)} ]',
//                                               style: Get.find<FontStyles>()
//                                                   .poppinsRegular
//                                                   .copyWith(
//                                                       fontSize: Dimensions
//                                                           .fontSizeExtraSmall,
//                                                       color: Theme.of(context)
//                                                           .cardColor),
//                                             )
//                                           : SizedBox(),
//                                       Text(
//                                         '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(widget.restaurant.discount.startTime)} '
//                                         '- ${DateConverter.convertTimeToTime(widget.restaurant.discount.endTime)} ]',
//                                         style: Get.find<FontStyles>()
//                                             .poppinsRegular
//                                             .copyWith(
//                                                 fontSize: Dimensions
//                                                     .fontSizeExtraSmall,
//                                                 color: Theme.of(context)
//                                                     .cardColor),
//                                       ),
//                                     ]),
//                               )
//                             : SizedBox(),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                             top: 10,
//                           ),
//                           child: Divider(
//                             height: 20,
//                             thickness: 3,
//                             color: Get.isDarkMode
//                                 ? Theme.of(context)
//                                     .disabledColor
//                                     .withOpacity(0.5)
//                                 : Colors.grey[300],
//                           ),
//                         )
//                       ]),
//                     )),

//                     CategoriesSelection(
//                         restaurant: widget.restaurant,
//                         restaurantViewModel: restaurantViewModel),
//                     // products section
//                     SliverToBoxAdapter(
//                         child: ListView.builder(
//                             padding: EdgeInsets.symmetric(
//                                 vertical: Dimensions.blockscreenVertical * 2),
//                             physics: NeverScrollableScrollPhysics(),
//                             key: UniqueKey(),
//                             shrinkWrap: true,
//                             itemCount: restaurantViewModel.categoryIndex == 0
//                                 ? restaurantViewModel
//                                     .restaurantAllProducts.length
//                                 : restaurantViewModel.categoryProducts.length,
//                             itemBuilder: (context, index) {
//                               Product product;
//                               if (restaurantViewModel.categoryIndex == 0) {
//                                 product = restaurantViewModel
//                                     .restaurantAllProducts[index];
//                               } else {
//                                 product =
//                                     restaurantViewModel.categoryProducts[index];
//                               }

//                               return ProductWidget(
//                                   product: product,
//                                   isRestaurant: false,
//                                   inRestaurant: true,
//                                   isCampaign: false,
//                                   restaurant: null,
//                                   index: product.id,
//                                   length: restaurantViewModel.categoryIndex == 0
//                                       ? restaurantViewModel
//                                           .restaurantAllProducts.length
//                                       : restaurantViewModel
//                                           .categoryProducts.length);
//                             })),
//                   ],
//                 );
//               }
//             }),
//         bottomNavigationBar: RestaurantBottomBar());
//   }
// }

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantScreen({Key key, @required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
        backgroundColor: Theme.of(context).backgroundColor,
        body: GetBuilder<RestuarantViewModel>(
            init: Get.find<RestuarantViewModel>()
              ..initRestaurantData(restaurant),
            // initState: (state) =>
            //     state.controller.initRestaurantData(restaurant),
            builder: (restaurantViewModel) {
              return Obx(() {
                if (restaurantViewModel.isLoading.isTrue) {
                  return Center(
                    child: CustomLoader(),
                  );
                }
                return CustomScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: ScrollController(),
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
                                                    '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: Dimensions
                                                  .PADDING_SIZE_LARGE),
                                          Expanded(
                                              child: RestaurantDescriptionView(
                                                  restaurant: restaurant)),
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
                                height: Dimensions.blockscreenHorizontal * 12,
                                width: Dimensions.blockscreenHorizontal * 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Get.isDarkMode
                                        ? Theme.of(context).backgroundColor
                                        : Colors.grey[200]),
                                alignment: Alignment.center,
                                child: Icon(Icons.chevron_left,
                                    size: 30,
                                    color: Theme.of(context).dividerColor),
                              ),
                              onPressed: () => Get.back(),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                                background: RestaurantImage(
                              restaurant: restaurant,
                              restaurantController:
                                  Get.find<RestaurantController>(),
                            )),
                            actions: [
                              IconButton(
                                onPressed: () => Get.toNamed(
                                    RouteHelper.getSearchRestaurantProductRoute(
                                        restaurant.id)),
                                icon: Container(
                                  height: Dimensions.blockscreenHorizontal * 12,
                                  width: Dimensions.blockscreenHorizontal * 12,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Get.isDarkMode
                                          ? Theme.of(context).backgroundColor
                                          : Colors.grey[200]),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.search,
                                      size: 30,
                                      color: Theme.of(context).dividerColor),
                                ),
                              )
                            ],
                          ),

                    // products
                    SliverToBoxAdapter(
                        child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Column(children: [
                        ResponsiveHelper.isDesktop(context)
                            ? SizedBox()

                            // restaurant description
                            : RestaurantDescriptionView(restaurant: restaurant),
                        restaurant.discount != null
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
                                        restaurant.discount.discountType ==
                                                'percent'
                                            ? '${restaurant.discount.discount}% OFF'
                                            : '${PriceConverter.convertPrice(restaurant.discount.discount)} OFF',
                                        style: Get.find<FontStyles>()
                                            .poppinsMedium
                                            .copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge,
                                                color: Theme.of(context)
                                                    .cardColor),
                                      ),
                                      Text(
                                        restaurant.discount.discountType ==
                                                'percent'
                                            ? '${'enjoy'.tr} ${restaurant.discount.discount}% ${'off_on_all_categories'.tr}'
                                            : '${'enjoy'.tr} ${PriceConverter.convertPrice(restaurant.discount.discount)}'
                                                ' ${'off_on_all_categories'.tr}',
                                        style: Get.find<FontStyles>()
                                            .poppinsMedium
                                            .copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .cardColor),
                                      ),
                                      SizedBox(
                                          height: (restaurant.discount
                                                          .minPurchase !=
                                                      0 ||
                                                  restaurant.discount
                                                          .maxDiscount !=
                                                      0)
                                              ? 5
                                              : 0),
                                      restaurant.discount.minPurchase != 0
                                          ? Text(
                                              '[ ${'minimum_purchase'.tr}: ${PriceConverter.convertPrice(restaurant.discount.minPurchase)} ]',
                                              style: Get.find<FontStyles>()
                                                  .poppinsRegular
                                                  .copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                            )
                                          : SizedBox(),
                                      restaurant.discount.maxDiscount != 0
                                          ? Text(
                                              '[ ${'maximum_discount'.tr}: ${PriceConverter.convertPrice(restaurant.discount.maxDiscount)} ]',
                                              style: Get.find<FontStyles>()
                                                  .poppinsRegular
                                                  .copyWith(
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall,
                                                      color: Theme.of(context)
                                                          .cardColor),
                                            )
                                          : SizedBox(),
                                      Text(
                                        '[ ${'daily_time'.tr}: ${DateConverter.convertTimeToTime(restaurant.discount.startTime)} '
                                        '- ${DateConverter.convertTimeToTime(restaurant.discount.endTime)} ]',
                                        style: Get.find<FontStyles>()
                                            .poppinsRegular
                                            .copyWith(
                                                fontSize: Dimensions
                                                    .fontSizeExtraSmall,
                                                color: Theme.of(context)
                                                    .cardColor),
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

                    CategoriesSelection(
                        restaurant: restaurant,
                        restaurantViewModel: restaurantViewModel),

                    // products section

                    restaurantViewModel.categoryProducts.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                                child: NoDataScreen(
                              text: "no_food_available".tr,
                            )),
                          )
                        : SliverToBoxAdapter(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.blockscreenVertical * 2),
                                physics: NeverScrollableScrollPhysics(),
                                key: UniqueKey(),
                                shrinkWrap: true,
                                itemCount:
                                    restaurantViewModel.categoryProducts.length,
                                itemBuilder: (context, index) {
                                  Product product;

                                  product = restaurantViewModel
                                      .categoryProducts[index];

                                  return ProductWidget(
                                      product: product,
                                      isRestaurant: false,
                                      inRestaurant: true,
                                      isCampaign: false,
                                      restaurant: null,
                                      index: product.id,
                                      length: restaurantViewModel
                                          .categoryProducts.length);
                                })),
                  ],
                );
              });
            }),
        bottomNavigationBar: RestaurantBottomBar());
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

import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/shop_by_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../controller/cart_controller.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../theme/font_styles.dart';
import '../../../util/colors.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_image.dart';
import '../../base/not_available_widget.dart';
import '../../base/paginated_list_view.dart';
import '../../base/product_view.dart';
import '../../base/title_widget.dart';
import '../home/home_screen.dart';
import '../home/widget/filter_view.dart';

class MartScreen extends StatefulWidget {
  MartScreen({Key key}) : super(key: key);

  @override
  State<MartScreen> createState() => _MartScreenState();
}

class _MartScreenState extends State<MartScreen> {
  final ScrollController scrollController = ScrollController();
  final restaurantController = Get.find<RestaurantController>();
  final categoryController = Get.find<CategoryController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      restaurantController.getRestaurantDetails(Restaurant(id: 12));

      categoryController.getSubCategoryList("15");

      // restaurantController.getRestaurantProductList(12, 1, 'all', false);

      Get.find<CartController>().getCartSubTotal();
    });

    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          restaurantController.restaurantProducts != null &&
          !Get.find<RestaurantController>().foodPaginate) {
        int pageSize =
            (Get.find<RestaurantController>().foodPageSize / 10).ceil();
        if (Get.find<RestaurantController>().foodOffset < pageSize) {
          restaurantController
              .setFoodOffset(Get.find<RestaurantController>().foodOffset + 1);
          print('end of the page');
          restaurantController.showFoodBottomLoader();
          restaurantController.getRestaurantProductList(
            12,
            restaurantController.foodOffset,
            restaurantController.type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child:
            GetBuilder<RestaurantController>(builder: (restaurantController) {
          return CustomScrollView(slivers: [
            SliverAppBar(
              toolbarHeight: Dimensions.blockscreenVertical * 10,
              expandedHeight: Dimensions.blockscreenVertical * 12,
              floating: false,
              pinned: true,
              elevation: 1,
              centerTitle: true,
              automaticallyImplyLeading: true,
              leading: InkWell(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).dividerColor,
                  )),
              backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                "fasteriy_mart".tr,
                style: Get.find<FontStyles>().poppinsRegular.copyWith(
                    color: Theme.of(context).dividerColor,
                    fontSize: Dimensions.blockscreenHorizontal * 4),
              ),
            ),

            // search button

            SliverPersistentHeader(
              pinned: false,
              delegate: SliverDelegate(
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
                      border:
                          Border.all(color: Theme.of(context).disabledColor),
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.circular(8),
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
              )),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  ShopByCategorySection(),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.blockscreenVertical * 3,
                            horizontal: Dimensions.blockscreenHorizontal * 4),
                        child: TitleWidget(
                            title: 'all_products'.tr,
                            onTap: () => Get.toNamed(
                                RouteHelper.getCategoryRoute(true))),
                      ),
                      SizedBox(
                        height: Dimensions.screeHeight * 0.33,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryController.categoryProductList !=
                                    null
                                ? categoryController.categoryProductList.length
                                : 4,
                            itemBuilder: ((context, index) {
                              return categoryController.categoryProductList !=
                                      null
                                  ? Container(
                                      width: Dimensions.screenWidth * 0.4,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.5,
                                                      color: Theme.of(context)
                                                          .disabledColor)),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .RADIUS_SMALL),
                                                child: CustomImage(
                                                  image:
                                                      '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                                                      '/${categoryController.categoryProductList[index].image}',
                                                  height:
                                                      (Dimensions.screeHeight *
                                                              0.30) *
                                                          0.7,
                                                  width:
                                                      Dimensions.screenWidth *
                                                          0.4,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            DateConverter.isAvailable(
                                                    categoryController
                                                        .categoryProductList[
                                                            index]
                                                        .availableTimeStarts,
                                                    categoryController
                                                        .categoryProductList[
                                                            index]
                                                        .availableTimeEnds)
                                                ? SizedBox()
                                                : NotAvailableWidget(
                                                    isRestaurant: false),
                                          ]),
                                          SizedBox(
                                            height:
                                                Dimensions.blockscreenVertical,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .blockscreenHorizontal,
                                                horizontal: Dimensions
                                                        .blockscreenHorizontal *
                                                    2),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  categoryController
                                                      .categoryProductList[
                                                          index]
                                                      .name,
                                                  maxLines: 2,
                                                  style: Get.find<FontStyles>()
                                                      .poppinsRegular
                                                      .copyWith(
                                                          fontSize: Dimensions
                                                                  .blockscreenHorizontal *
                                                              3.5),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(children: [
                                                  Text(
                                                    PriceConverter.convertPrice(
                                                        categoryController
                                                            .categoryProductList[
                                                                index]
                                                            .price,
                                                        discount: categoryController
                                                            .categoryProductList[
                                                                index]
                                                            .discount,
                                                        discountType:
                                                            categoryController
                                                                .categoryProductList[
                                                                    index]
                                                                .discountType),
                                                    style: Get.find<
                                                            FontStyles>()
                                                        .poppinsMedium
                                                        .copyWith(
                                                            fontSize: Dimensions
                                                                    .blockscreenHorizontal *
                                                                4),
                                                  ),
                                                  SizedBox(
                                                      width: categoryController
                                                                  .categoryProductList[
                                                                      index]
                                                                  .discount >
                                                              0
                                                          ? Dimensions
                                                              .PADDING_SIZE_EXTRA_SMALL
                                                          : 0),
                                                  categoryController
                                                              .categoryProductList[
                                                                  index]
                                                              .discount >
                                                          0
                                                      ? Text(
                                                          PriceConverter.convertPrice(
                                                              categoryController
                                                                  .categoryProductList[
                                                                      index]
                                                                  .price),
                                                          style: Get.find<FontStyles>().poppinsRegular.copyWith(
                                                              fontSize: Dimensions
                                                                      .blockscreenHorizontal *
                                                                  3.2,
                                                              color: Theme.of(
                                                                      context)
                                                                  .dividerColor,
                                                              decorationThickness:
                                                                  20,
                                                              decorationColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .dividerColor,
                                                              decorationStyle:
                                                                  TextDecorationStyle
                                                                      .solid,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        )
                                                      : SizedBox()
                                                ]),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[300],
                                        margin: EdgeInsets.only(
                                          left: index == 0
                                              ? 0
                                              : Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL,
                                          right: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL,
                                        ),
                                        child: Shimmer(
                                          duration: Duration(seconds: 2),
                                          enabled: categoryController
                                                  .subCategoryList ==
                                              null,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            })),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.blockscreenVertical * 3,
                        horizontal: Dimensions.blockscreenHorizontal * 3),
                    child: Row(children: [
                      Expanded(
                          child: Text(
                        'all_restaurants'.tr,
                        style: Get.find<FontStyles>().poppinsRegular.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 3.5,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).dividerColor),
                      )),
                      FilterView(),
                    ]),
                  ),
                  GetBuilder<RestaurantController>(
                      builder: (restaurantController) {
                    return PaginatedListView(
                      scrollController: ScrollController(),
                      totalSize: restaurantController.restaurantModel != null
                          ? restaurantController.restaurantModel.totalSize
                          : null,
                      offset: restaurantController.restaurantModel != null
                          ? restaurantController.restaurantModel.offset
                          : null,
                      onPaginate: (int offset) async =>
                          await restaurantController.getRestaurantList(
                              offset, false),
                      productView: ProductView(
                        isRestaurant: true,
                        products: null,
                        showTheme1Restaurant: true,
                        restaurants: restaurantController.restaurantModel !=
                                null
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
                ],
              ),
            )
          ]);
        }),
      ),
    );
  }
}

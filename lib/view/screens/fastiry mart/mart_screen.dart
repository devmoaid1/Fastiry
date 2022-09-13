import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/mart_viewModel.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/all_mart_products.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/shop_by_category.dart';
import 'package:efood_multivendor/view/screens/restaurant/widget/restaurant_bottom._bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/cart_controller.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/route_helper.dart';
import '../../../theme/font_styles.dart';
import '../../../util/colors.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../home/home_screen.dart';

class MartScreen extends StatelessWidget {
  const MartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        bottomSheet: cartController.cartList.isNotEmpty
            ? cartController.cartList.first.product.restaurantId == 12
                ? RestaurantBottomBar()
                : Container(height: 0)
            : Container(height: 0),
        body: GetBuilder<MartViewModel>(
          init: Get.find<MartViewModel>()..martScreenIntial(),
          builder: (martViewModel) => SafeArea(
              child: CustomScrollView(slivers: [
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
                  onTap: () => Get.toNamed(
                      RouteHelper.getSearchRestaurantProductRoute(12)),
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
                        'search_products'.tr,
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
              child: GetBuilder<CategoryController>(
                builder: (cateController) => Column(
                  children: [
                    SizedBox(
                      height: Dimensions.blockscreenVertical * 4,
                    ),
                    martViewModel.isLoading || martViewModel.fastiryMart == null
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              height: Dimensions.blockscreenVertical * 9,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Images.ordersIcon,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                          width: 25,
                                          height: 25,
                                        ),
                                        SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL,
                                        ),
                                        Text(
                                          PriceConverter.convertPrice(
                                              martViewModel
                                                  .fastiryMart.minimumOrder),
                                          style: Get.find<FontStyles>()
                                              .poppinsMedium
                                              .copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    3.5,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                        ),
                                      ]),
                                  // Expanded(child: SizedBox()),
                                  Column(children: [
                                    SvgPicture.asset(
                                      Images.clockIcon,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      width: 25,
                                      height: 25,
                                    ),
                                    SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    Text(
                                      '${martViewModel.fastiryMart.deliveryTime} ${'min'.tr}',
                                      style: Get.find<FontStyles>()
                                          .poppinsRegular
                                          .copyWith(
                                              fontSize: Dimensions
                                                      .blockscreenHorizontal *
                                                  3.5,
                                              color: Theme.of(context)
                                                  .disabledColor),
                                    ),
                                  ]),
                                  // Expanded(child: SizedBox()),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        Images.scooterIconSvg,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                        width:
                                            Dimensions.blockscreenHorizontal *
                                                5,
                                        height:
                                            Dimensions.blockscreenHorizontal *
                                                5,
                                      ),
                                      SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Text(
                                        martViewModel.fastiryMart
                                                    .deliveryPrice !=
                                                0
                                            ? PriceConverter.convertPrice(
                                                martViewModel
                                                    .fastiryMart.deliveryPrice)
                                            : "free_delivery".tr,
                                        style: Get.find<FontStyles>()
                                            .poppinsRegular
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .disabledColor,
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    3.5),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                ]),
                          ),
                    SizedBox(height: Dimensions.blockscreenVertical * 2),
                    ShopByCategorySection(martViewModel: martViewModel),
                    AllMartProductsSection(
                      martViewModel: martViewModel,
                    )
                  ],
                ),
              ),
            )
          ])),
        ),
      ),
    );
  }
}

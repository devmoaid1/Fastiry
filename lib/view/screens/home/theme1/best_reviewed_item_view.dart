import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/discount_tag.dart';
import 'package:efood_multivendor/view/base/not_available_widget.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../util/image_checker.dart';
import '../../product_details/productDetails.dart';

class BestReviewedItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      List<Product> _productList = productController.reviewedProductList;

      return (_productList != null && _productList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.blockscreenVertical * 3,
                      horizontal: Dimensions.blockscreenHorizontal * 4),
                  child: TitleWidget(
                    title: 'best_reviewed_food'.tr,
                    onTap: () =>
                        Get.toNamed(RouteHelper.getPopularFoodRoute(false)),
                  ),
                ),
                SizedBox(
                  height: Dimensions.blockscreenVertical * 34,
                  child: _productList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount: _productList.length > 10
                              ? 10
                              : _productList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: 5),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                      RouteHelper.getProductDetailsRoute(
                                          _productList[index].id),
                                      arguments: ProductDetailsScreen(
                                        product: _productList[index],
                                        isCampaign: false,
                                      ));
                                },
                                child: Container(
                                  height: Dimensions.blockscreenVertical * 13,
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
                                          MainAxisAlignment.start,
                                      children: [
                                        Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(
                                                    Dimensions.RADIUS_SMALL)),
                                            child: checkImage(
                                                '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${_productList[index].image}',
                                                Dimensions
                                                        .blockscreenHorizontal *
                                                    50,
                                                Dimensions.blockscreenVertical *
                                                    13,
                                                BoxFit.fill),
                                          ),
                                          productController.isAvailable(
                                                  _productList[index])
                                              ? SizedBox()
                                              : NotAvailableWidget(
                                                  isRestaurant: true),
                                        ]),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .blockscreenVertical,
                                                horizontal: Dimensions
                                                        .blockscreenHorizontal *
                                                    2),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FoodDetailsRow(
                                                    productList: _productList,
                                                    index: index,
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                              .blockscreenVertical *
                                                          2),
                                                  PriceRow(
                                                    productList: _productList,
                                                    productController:
                                                        productController,
                                                    index: index,
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                            .blockscreenVertical *
                                                        2,
                                                  ),
                                                  DiscountTag(
                                                    discount:
                                                        _productList[index]
                                                            .discount,
                                                    discountType:
                                                        _productList[index]
                                                            .discountType,
                                                  )
                                                ]),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          },
                        )
                      : BestReviewedItemShimmer(
                          productController: productController),
                ),
              ],
            );
    });
  }
}

class PriceRow extends StatelessWidget {
  const PriceRow(
      {Key key,
      @required List<Product> productList,
      this.productController,
      this.index})
      : _productList = productList,
        super(key: key);

  final List<Product> _productList;
  final ProductController productController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                SvgPicture.asset(
                  Images.priceTagIcon,
                  height: 18,
                  color: Theme.of(context).dividerColor,
                ),
                SizedBox(
                  width: Dimensions.blockscreenHorizontal,
                ),
                Text(
                  PriceConverter.convertPrice(
                    productController.getStartingPrice(_productList[index]),
                    discount:
                        productController.getDiscount(_productList[index]),
                    discountType:
                        productController.getDiscountType(_productList[index]),
                  ),
                  style: poppinsMedium.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 3),
                ),
                SizedBox(
                    width: _productList[index].discount > 0
                        ? Dimensions.blockscreenHorizontal * 2
                        : 0),
                productController.getDiscount(_productList[index]) > 0
                    ? Text(
                        PriceConverter.convertPrice(productController
                            .getStartingPrice(_productList[index])),
                        style: poppinsRegular.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 3,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.6),
                          decoration: TextDecoration.lineThrough,
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ]),
    );
  }
}

class FoodDetailsRow extends StatelessWidget {
  const FoodDetailsRow({
    Key key,
    this.index,
    @required List<Product> productList,
  })  : _productList = productList,
        super(key: key);

  final List<Product> _productList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                Images.breakFastImage,
                height: Dimensions.blockscreenVertical * 6,
                width: Dimensions.blockscreenHorizontal * 8,
                fit: BoxFit.fill,
                isAntiAlias: true,
              ),
            ),
            SizedBox(
              width: Dimensions.blockscreenHorizontal * 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 100),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      _productList[index].name ?? '',
                      textAlign: TextAlign.center,
                      style: poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 4),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.fill,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: Text(
                      _productList[index].restaurantName ?? '',
                      textAlign: TextAlign.center,
                      style: poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 3,
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.6)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(children: [
          Icon(Icons.star, color: Colors.orangeAccent[200], size: 15),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(_productList[index].avgRating.toStringAsFixed(1),
              style: poppinsRegular),
        ])
      ],
    );
  }
}

class BestReviewedItemShimmer extends StatelessWidget {
  final ProductController productController;
  BestReviewedItemShimmer({@required this.productController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          child: Container(
            height: 220,
            width: 180,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                  color: Colors
                      .grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ],
            ),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: Get.find<HomeController>().isLoading,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(children: [
                      Container(
                        height: 125,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(Dimensions.RADIUS_SMALL)),
                          color: Colors.grey[300],
                        ),
                      ),
                      Positioned(
                        top: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        left: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(0.8),
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          ),
                          child: Row(children: [
                            Icon(Icons.star,
                                color: Theme.of(context).primaryColor,
                                size: 15),
                            SizedBox(
                                width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Text('0.0', style: robotoRegular),
                          ]),
                        ),
                      ),
                    ]),
                    Expanded(
                      child: Stack(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                    height: 15,
                                    width: 100,
                                    color: Colors.grey[300]),
                                SizedBox(height: 2),
                                Container(
                                    height: 10,
                                    width: 70,
                                    color: Colors.grey[300]),
                                SizedBox(
                                    height:
                                        Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          height: 10,
                                          width: 40,
                                          color: Colors.grey[300]),
                                      SizedBox(
                                          width: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      Container(
                                          height: 15,
                                          width: 40,
                                          color: Colors.grey[300]),
                                    ]),
                              ]),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor),
                              child: Icon(Icons.add,
                                  size: 20, color: Colors.white),
                            )),
                      ]),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}

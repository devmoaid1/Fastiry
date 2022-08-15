import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:efood_multivendor/view/base/quantity_button.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../../theme/font_styles.dart';
import '../../util/images.dart';
import 'confirmation_dialog.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;
  final bool inRestaurantPage;
  ProductBottomSheet(
      {@required this.product,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inRestaurantPage = false});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  @override
  void initState() {
    super.initState();

    Get.find<ProductController>().initData(widget.product, widget.cart);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.screeHeight * 0.6,
      width: double.infinity,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: ResponsiveHelper.isMobile(context)
            ? BorderRadius.vertical(
                top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
            : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
      ),
      child: GetBuilder<ProductController>(builder: (productController) {
        double _startingPrice;
        double _endingPrice;
        if (widget.product.choiceOptions.length != 0) {
          List<double> _priceList = [];
          widget.product.variations
              .forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = widget.product.price;
        }

        List<String> _variationList = [];
        for (int index = 0;
            index < widget.product.choiceOptions.length;
            index++) {
          _variationList.add(widget.product.choiceOptions[index]
              .options[productController.variationIndex[index]]
              .replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = widget.product.price;
        Variation _variation;
        for (Variation variation in widget.product.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            break;
          }
        }

        double _discount =
            (widget.isCampaign || widget.product.restaurantDiscount == 0)
                ? widget.product.discount
                : widget.product.restaurantDiscount;
        String _discountType =
            (widget.isCampaign || widget.product.restaurantDiscount == 0)
                ? widget.product.discountType
                : 'percent';
        double priceWithDiscount =
            PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity =
            priceWithDiscount * productController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < widget.product.addOns.length; index++) {
          if (productController.addOnActiveList[index]) {
            addonsCost = addonsCost +
                (widget.product.addOns[index].price *
                    productController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(
                id: widget.product.addOns[index].id,
                quantity: productController.addOnQtyList[index]));
            _addOnsList.add(widget.product.addOns[index]);
          }
        }
        double priceWithAddons = priceWithQuantity + addonsCost;
        // bool _isRestAvailable = DateConverter.isAvailable(widget.product.restaurantOpeningTime, widget.product.restaurantClosingTime);
        bool _isAvailable = DateConverter.isAvailable(
            widget.product.availableTimeStarts,
            widget.product.availableTimeEnds);

        CartModel _cartModel = CartModel(
          price,
          priceWithDiscount,
          _variation != null ? [_variation] : [],
          (price -
              PriceConverter.convertWithDiscount(
                  price, _discount, _discountType)),
          productController.quantity,
          _addOnIdList,
          _addOnsList,
          widget.isCampaign,
          widget.product,
        );
        //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

        return SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // image
                (widget.product.image != null &&
                        widget.product.image.isNotEmpty)
                    ? Stack(children: [
                        InkWell(
                          onTap: widget.isCampaign
                              ? null
                              : () {
                                  if (!widget.isCampaign) {
                                    Get.toNamed(RouteHelper.getItemImagesRoute(
                                        widget.product));
                                  }
                                },
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: CustomImage(
                              image:
                                  '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                              width: double.infinity,
                              height: Dimensions.screeHeight * 0.25,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                              onTap: () => Get.back(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: Dimensions.blockscreenHorizontal,
                                  left: Dimensions.blockscreenHorizontal,
                                ),
                                child: Icon(Icons.close, color: Colors.white),
                              )),
                        ),
                      ])
                    : SizedBox.shrink(),

                // details
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Product

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.blockscreenHorizontal * 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Get.find<FontStyles>()
                                    .poppinsMedium
                                    .copyWith(
                                        color: Theme.of(context).dividerColor,
                                        fontSize:
                                            Dimensions.blockscreenHorizontal *
                                                5)),
                            SizedBox(
                              height: Dimensions.blockscreenVertical,
                            ),
                            Row(
                              children: [
                                Text(
                                  PriceConverter.convertPrice(
                                      widget.product.price,
                                      discount: _discount,
                                      discountType: _discountType),
                                  style: Get.find<FontStyles>()
                                      .poppinsMedium
                                      .copyWith(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize:
                                              Dimensions.blockscreenHorizontal *
                                                  4),
                                ),
                                SizedBox(
                                    width: _discount > 0
                                        ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                                        : 0),
                                _discount > 0
                                    ? Text(
                                        PriceConverter.convertPrice(
                                            widget.product.price),
                                        style: Get.find<FontStyles>()
                                            .poppinsRegular
                                            .copyWith(
                                              fontSize: Dimensions
                                                      .blockscreenHorizontal *
                                                  3.2,
                                              color: Theme.of(context)
                                                  .disabledColor
                                                  .withOpacity(0.7),
                                              decoration:
                                                  TextDecoration.lineThrough,
                                            ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar(
                                    rating: widget.product.avgRating,
                                    ratingCount: widget.product.ratingCount),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        !Get.isDarkMode
                                            ? BoxShadow(
                                                blurRadius: 7,
                                                offset: Offset(2, 4),
                                                spreadRadius: 0.4,
                                                color: Colors.grey[300])
                                            : BoxShadow()
                                      ]),
                                  child: Row(children: [
                                    QuantityButton(
                                      fromProductPage: true,
                                      onTap: () {
                                        if (productController.quantity > 1) {
                                          productController.setQuantity(false);
                                        }
                                      },
                                      isIncrement: false,
                                      canDecrement:
                                          productController.quantity != 1,
                                    ),
                                    Text(productController.quantity.toString(),
                                        style: Get.find<FontStyles>()
                                            .poppinsMedium
                                            .copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeLarge)),
                                    QuantityButton(
                                      fromProductPage: true,
                                      onTap: () =>
                                          productController.setQuantity(true),
                                      isIncrement: true,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Divider(
                                height: 20,
                                thickness: 5,
                                color: Get.isDarkMode
                                    ? Theme.of(context)
                                        .disabledColor
                                        .withOpacity(0.5)
                                    : Colors.grey[200],
                              ),
                            )
                          ],
                        ),
                      )
                    ]),
                // Variation
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.product.choiceOptions.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.choiceOptions[index].title,
                                style: Get.find<FontStyles>().poppinsMedium),
                            SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    ResponsiveHelper.isMobile(context) ? 3 : 4,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 10,
                                childAspectRatio: (1 / 0.25),
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget
                                  .product.choiceOptions[index].options.length,
                              itemBuilder: (context, i) {
                                return InkWell(
                                  onTap: () {
                                    print(
                                        '---check for update  ${widget.cart != null ? widget.cart.toJson() : null} and ${productController.cartIndex}-----');
                                    print(
                                        '-----and ${productController.cartIndex}///-----');
                                    productController.setCartVariationIndex(
                                        index, i, widget.product);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    decoration: BoxDecoration(
                                      color: productController
                                                  .variationIndex[index] !=
                                              i
                                          ? Theme.of(context).backgroundColor
                                          : Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      border: productController
                                                  .variationIndex[index] !=
                                              i
                                          ? Border.all(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              width: 2)
                                          : null,
                                    ),
                                    child: Text(
                                      widget.product.choiceOptions[index]
                                          .options[i]
                                          .trim(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Get.find<FontStyles>()
                                          .poppinsRegular
                                          .copyWith(
                                            color: productController
                                                            .variationIndex[
                                                        index] !=
                                                    i
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                                height: index !=
                                        widget.product.choiceOptions.length - 1
                                    ? Dimensions.PADDING_SIZE_LARGE
                                    : 0),
                          ]),
                    );
                  },
                ),
                SizedBox(
                    height: widget.product.choiceOptions.length > 0
                        ? Dimensions.PADDING_SIZE_LARGE
                        : 0),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                // Addons
                widget.product.addOns.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('addons'.tr,
                                style: Get.find<FontStyles>().poppinsMedium),
                            SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 10,
                                childAspectRatio: (1 / 1.1),
                              ),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.product.addOns.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (!productController
                                        .addOnActiveList[index]) {
                                      productController.addAddOn(true, index);
                                    } else if (productController
                                            .addOnQtyList[index] ==
                                        1) {
                                      productController.addAddOn(false, index);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        bottom: productController
                                                .addOnActiveList[index]
                                            ? 2
                                            : 20),
                                    decoration: BoxDecoration(
                                      color: productController
                                              .addOnActiveList[index]
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).backgroundColor,
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      border: productController
                                              .addOnActiveList[index]
                                          ? null
                                          : Border.all(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              width: 2),
                                      boxShadow: productController
                                              .addOnActiveList[index]
                                          ? [
                                              BoxShadow(
                                                  color: Colors.grey[
                                                      Get.isDarkMode
                                                          ? 700
                                                          : 300],
                                                  blurRadius: 5,
                                                  spreadRadius: 1)
                                            ]
                                          : null,
                                    ),
                                    child: Column(children: [
                                      Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget
                                                    .product.addOns[index].name,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                                style: Get.find<FontStyles>()
                                                    .poppinsMedium
                                                    .copyWith(
                                                      color: productController
                                                                  .addOnActiveList[
                                                              index]
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: Dimensions
                                                          .fontSizeSmall,
                                                    ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                widget.product.addOns[index]
                                                            .price >
                                                        0
                                                    ? PriceConverter
                                                        .convertPrice(widget
                                                            .product
                                                            .addOns[index]
                                                            .price)
                                                    : 'free'.tr,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Get.find<FontStyles>()
                                                    .poppinsRegular
                                                    .copyWith(
                                                      color: productController
                                                                  .addOnActiveList[
                                                              index]
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: Dimensions
                                                          .fontSizeExtraSmall,
                                                    ),
                                              ),
                                            ]),
                                      ),
                                      productController.addOnActiveList[index]
                                          ? Container(
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .RADIUS_SMALL),
                                                  color: Theme.of(context)
                                                      .cardColor),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          if (productController
                                                                      .addOnQtyList[
                                                                  index] >
                                                              1) {
                                                            productController
                                                                .setAddOnQuantity(
                                                                    false,
                                                                    index);
                                                          } else {
                                                            productController
                                                                .addAddOn(false,
                                                                    index);
                                                          }
                                                        },
                                                        child: Center(
                                                            child: Icon(
                                                                Icons.remove,
                                                                size: 15)),
                                                      ),
                                                    ),
                                                    Text(
                                                      productController
                                                          .addOnQtyList[index]
                                                          .toString(),
                                                      style: Get.find<
                                                              FontStyles>()
                                                          .poppinsMedium
                                                          .copyWith(
                                                              fontSize: Dimensions
                                                                  .fontSizeSmall),
                                                    ),
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () =>
                                                            productController
                                                                .setAddOnQuantity(
                                                                    true,
                                                                    index),
                                                        child: Center(
                                                            child: Icon(
                                                                Icons.add,
                                                                size: 15)),
                                                      ),
                                                    ),
                                                  ]),
                                            )
                                          : SizedBox(),
                                    ]),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          ])
                    : SizedBox(),

                SizedBox(height: Dimensions.blockscreenVertical),

                //Add to cart Button
                _isAvailable
                    ? SizedBox()
                    : Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        margin: EdgeInsets.only(
                            bottom: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        child: Column(children: [
                          Text('not_available_now'.tr,
                              style:
                                  Get.find<FontStyles>().poppinsMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeLarge,
                                      )),
                          Text(
                            '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts)} '
                            '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds)}',
                            style: Get.find<FontStyles>().poppinsRegular,
                          ),
                        ]),
                      ),

                (!widget.product.scheduleOrder && !_isAvailable)
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 8),
                        child: InkWell(
                          onTap: () {
                            if (Get.find<CartController>()
                                .existAnotherRestaurantProduct(
                                    _cartModel.product.restaurantId)) {
                              Get.dialog(
                                  ConfirmationDialog(
                                    icon: Images.warning,
                                    title: 'are_you_sure_to_reset'.tr,
                                    description: 'if_you_continue'.tr,
                                    onYesPressed: () {
                                      Get.back();
                                      Get.find<CartController>()
                                          .removeAllAndAddToCart(_cartModel);
                                      _showCartSnackBar();
                                    },
                                  ),
                                  barrierDismissible: false);
                            } else {
                              Get.find<CartController>().addToCart(
                                  _cartModel,
                                  widget.cartIndex != null
                                      ? widget.cartIndex
                                      : productController.cartIndex);
                              _showCartSnackBar();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: Dimensions.blockscreenVertical * 2,
                                horizontal:
                                    Dimensions.blockscreenHorizontal * 2),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(children: [
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Add to bascket",
                                      style: Get.find<FontStyles>()
                                          .poppinsRegular
                                          .copyWith(color: Colors.white),
                                    ),
                                    Text(
                                      PriceConverter.convertPrice(
                                          priceWithAddons),
                                      style: Get.find<FontStyles>()
                                          .poppinsRegular
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),

                //
              ]),
        );
      }),
    );
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(
          label: 'view_cart'.tr,
          textColor: Colors.white,
          onPressed: () {
            Get.toNamed(RouteHelper.getCartRoute());
          }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      content: Text(
        'item_added_to_cart'.tr,
        style:
            Get.find<FontStyles>().poppinsMedium.copyWith(color: Colors.white),
      ),
    ));
    Get.showSnackbar(GetSnackBar(
      backgroundColor: Colors.green,
      message: 'item_added_to_cart'.tr,
      mainButton: TextButton(
        onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
        child: Text('view_cart'.tr,
            style: Get.find<FontStyles>()
                .poppinsMedium
                .copyWith(color: Colors.white)),
      ),
      onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
      duration: Duration(seconds: 4),
      maxWidth: Dimensions.WEB_MAX_WIDTH,
      snackStyle: SnackStyle.FLOATING,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}

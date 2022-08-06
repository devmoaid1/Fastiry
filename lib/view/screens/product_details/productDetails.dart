import 'package:efood_multivendor/view/screens/product_details/widgets/add_ons_cards.dart';
import 'package:efood_multivendor/view/screens/product_details/widgets/add_to_bascket_bottom.dart';
import 'package:efood_multivendor/view/screens/product_details/widgets/not_available.dart';
import 'package:efood_multivendor/view/screens/product_details/widgets/product_details_card.dart';
import 'package:efood_multivendor/view/screens/product_details/widgets/product_image.dart';
import 'package:efood_multivendor/view/screens/product_details/widgets/variation_cards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/product_controller.dart';
import '../../../data/model/response/cart_model.dart';
import '../../../data/model/response/product_model.dart';
import '../../../helper/date_converter.dart';
import '../../../helper/price_converter.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cartItem;
  ProductDetailsScreen(
      {Key key, @required this.product, this.isCampaign = false, this.cartItem})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ProductController>().initData(widget.product, widget.cartItem);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
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
      double priceWithQuantity = priceWithDiscount * productController.quantity;
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
          widget.product.availableTimeStarts, widget.product.availableTimeEnds);

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

      return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: SafeArea(
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: ResponsiveHelper.isMobile(context)
                        ? BorderRadius.vertical(
                            top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
                        : BorderRadius.all(
                            Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image
                          (widget.product.image != null &&
                                  widget.product.image.isNotEmpty)
                              //image
                              ? ProductImage(product: widget.product)
                              : SizedBox.shrink(),

                          // details
                          ProductDetailsCard(
                              productController: productController,
                              product: widget.product,
                              discount: _discount,
                              discountType: _discountType),
                          SizedBox(height: Dimensions.blockscreenVertical),
                          // Variation
                          VariationCards(
                              productController: productController,
                              product: widget.product),

                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // Addons
                          widget.product.addOns.length > 0
                              ? AddOnsCards(
                                  product: widget.product,
                                  productController: productController)
                              : SizedBox(),

                          SizedBox(height: Dimensions.blockscreenVertical),

                          //Add to cart Button
                          _isAvailable
                              ? SizedBox()
                              : ProductNotAvailableCard(product: widget.product)

                          // (!widget.product.scheduleOrder && !_isAvailable)
                          //     ? SizedBox()
                          //     :

                          //
                        ]),
                  ))),
          bottomNavigationBar: AddToBascketBottomBar(
            cartModel: _cartModel,
            totalPrice: priceWithAddons,
          ));
    });
  }
}

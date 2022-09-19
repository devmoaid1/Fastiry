import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/data/model/response/cart_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';
import '../../../base/quantity_button.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;
  final List<AddOns> addOns;
  final bool isAvailable;
  CartProductWidget(
      {@required this.cart,
      @required this.cartIndex,
      @required this.isAvailable,
      @required this.addOns});

  @override
  Widget build(BuildContext context) {
    String _addOnText = '';
    int _index = 0;
    List<int> _ids = [];
    List<int> _qtys = [];
    cart.addOnIds.forEach((addOn) {
      _ids.add(addOn.id);
      _qtys.add(addOn.quantity);
    });
    cart.product.addOns.forEach((addOn) {
      if (_ids.contains(addOn.id)) {
        _addOnText = _addOnText +
            '${(_index == 0) ? '' : ',  '}${addOn.name} (${_qtys[_index]})';
        _index = _index + 1;
      }
    });

    String _variationText = '';
    if (cart.variation.length > 0) {
      List<String> _variationTypes = cart.variation[0].type.split('-');
      if (_variationTypes.length == cart.product.choiceOptions.length) {
        int _index = 0;
        cart.product.choiceOptions.forEach((choice) {
          _variationText = _variationText +
              '${(_index == 0) ? '' : ',  '}${choice.title} - ${_variationTypes[_index]}';
          _index = _index + 1;
        });
      } else {
        _variationText = cart.product.variations[0].type;
      }
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.blockscreenVertical * 1.5),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            horizontal: Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: Column(
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              (cart.product.image != null && cart.product.image.isNotEmpty)
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: CustomImage(
                            image:
                                '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${cart.product.image}',
                            height: Dimensions.blockscreenVertical * 15,
                            width: Dimensions.blockscreenVertical * 15,
                            fit: BoxFit.cover,
                          ),
                        ),
                        isAvailable
                            ? SizedBox()
                            : Positioned(
                                top: 0,
                                left: 0,
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      color: Colors.black.withOpacity(0.6)),
                                  child: Text('not_available_now_break'.tr,
                                      textAlign: TextAlign.center,
                                      style: robotoRegular.copyWith(
                                        color: Colors.white,
                                        fontSize: 8,
                                      )),
                                ),
                              ),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Container(
                          width: Dimensions.blockscreenHorizontal * 40,
                          child: Text(
                            cart.product.name,
                            style: Get.find<FontStyles>()
                                .poppinsMedium
                                .copyWith(
                                    fontSize:
                                        Dimensions.blockscreenHorizontal * 5),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.blockscreenVertical * 1),
                      FittedBox(
                        fit: BoxFit.fill,
                        child: Container(
                          width: Dimensions.blockscreenHorizontal * 35,
                          child: Text(
                            PriceConverter.convertPrice(
                                cart.discountedPrice + cart.discountAmount),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Get.find<FontStyles>()
                                .poppinsRegular
                                .copyWith(
                                    fontSize:
                                        Dimensions.blockscreenHorizontal * 4.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            QuantityButton(
                              fromProductPage: false,
                              onTap: () {
                                if (cart.quantity > 1) {
                                  Get.find<CartController>()
                                      .setQuantity(false, cart);
                                } else {
                                  Get.find<CartController>()
                                      .removeFromCart(cartIndex);
                                }
                              },
                              isIncrement: false,
                              canDecrement: cart.quantity != 1,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(cart.quantity.toString(),
                                  style: Get.find<FontStyles>()
                                      .poppinsMedium
                                      .copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraLarge)),
                            ),
                            QuantityButton(
                              fromProductPage: false,
                              onTap: () => Get.find<CartController>()
                                  .setQuantity(true, cart),
                              isIncrement: true,
                            ),
                          ]),
                    ]),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

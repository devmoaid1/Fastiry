import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/cart_controller.dart';
import '../../../../controller/product_controller.dart';
import '../../../../data/model/response/cart_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/route_helper.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/confirmation_dialog.dart';

class AddToBascketBottomBar extends StatelessWidget {
  final CartModel cartModel;
  final double totalPrice;

  const AddToBascketBottomBar({Key key, this.cartModel, this.totalPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Container(
          height: 80,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                !Get.isDarkMode
                    ? BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(4, 4),
                        blurRadius: 4,
                        spreadRadius: 0.5)
                    : BoxShadow(color: Theme.of(context).backgroundColor)
              ],
              border: Border.fromBorderSide(BorderSide(
                  color: !Get.isDarkMode
                      ? Colors.grey[400]
                      : Theme.of(context).backgroundColor,
                  width: 0.5))),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
          child: InkWell(
            onTap: () {
              if (Get.find<CartController>().existAnotherRestaurantProduct(
                  cartModel.product.restaurantId)) {
                Get.dialog(
                    ConfirmationDialog(
                      icon: Images.warning,
                      title: 'are_you_sure_to_reset'.tr,
                      description: 'if_you_continue'.tr,
                      onYesPressed: () {
                        Get.back();
                        Get.find<CartController>()
                            .removeAllAndAddToCart(cartModel);
                        // _showCartSnackBar();
                      },
                    ),
                    barrierDismissible: false);
              } else {
                Get.find<CartController>()
                    .addToCart(cartModel, productController.cartIndex);
                // _showCartSnackBar();
                Get.back();
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.blockscreenVertical * 2,
                  horizontal: Dimensions.blockscreenHorizontal * 2),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "add_to_bascket".tr,
                        style: Get.find<FontStyles>()
                            .poppinsRegular
                            .copyWith(color: Colors.white),
                      ),
                      Text(
                        PriceConverter.convertPrice(totalPrice),
                        style: Get.find<FontStyles>()
                            .poppinsRegular
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ));
    });
  }
}

void _showCartSnackBar() {
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

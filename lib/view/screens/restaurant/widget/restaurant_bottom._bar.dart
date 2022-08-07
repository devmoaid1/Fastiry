import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/price_converter.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class RestaurantBottomBar extends StatelessWidget {
  final CartController cartController;
  const RestaurantBottomBar({Key key, @required this.cartController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.blockscreenVertical * 2,
          horizontal: Dimensions.blockscreenHorizontal * 3),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: [
        !Get.isDarkMode
            ? BoxShadow(
                blurRadius: 7, spreadRadius: 0.4, color: Colors.grey[300])
            : BoxShadow(color: Theme.of(context).backgroundColor)
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
                cartController.cartList.length.toString(),
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
                    "view_bascket".tr,
                    style: poppinsRegular.copyWith(color: Colors.white),
                  ),
                  Text(
                    PriceConverter.convertPrice(cartController.cartSubTotal),
                    style: poppinsRegular.copyWith(color: Colors.white),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

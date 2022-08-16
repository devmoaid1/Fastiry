import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';

class PaymentButton extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final int index;
  PaymentButton(
      {@required this.index,
      @required this.icon,
      @required this.title,
      @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentMethodIndex == index;
      return Padding(
        padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
        child: InkWell(
          onTap: () => orderController.setPaymentMethod(index),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border.all(
                color: !_selected
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).primaryColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                !Get.isDarkMode
                    ? BoxShadow(
                        color: Colors.grey[200], blurRadius: 5, spreadRadius: 1)
                    : BoxShadow(color: Theme.of(context).backgroundColor)
              ],
            ),
            child: ListTile(
              leading: Image.asset(
                icon,
                width: 40,
                height: 40,
                color: _selected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
              ),
              title: Text(
                title,
                style: Get.find<FontStyles>()
                    .poppinsMedium
                    .copyWith(fontSize: Dimensions.fontSizeSmall),
              ),
              subtitle: Text(
                subtitle,
                style: Get.find<FontStyles>().poppinsRegular.copyWith(
                    fontSize: Dimensions.fontSizeExtraSmall,
                    color: Theme.of(context).disabledColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: _selected
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
            ),
          ),
        ),
      );
    });
  }
}

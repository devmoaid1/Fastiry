import '/controller/order_controller.dart';
import '/helper/price_converter.dart';
import '/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';

class DeliveryOptionButton extends StatelessWidget {
  final String value;
  final String title;
  final double charge;
  final bool isFree;
  DeliveryOptionButton(
      {@required this.value,
      @required this.title,
      @required this.charge,
      @required this.isFree});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        return InkWell(
          onTap: () => orderController.setOrderType(value),
          child: Row(
            children: [
              Radio(
                value: value,
                groupValue: orderController.orderType,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (String value) =>
                    orderController.setOrderType(value),
                activeColor: Theme.of(context).primaryColor,
              ),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
              Text(title, style: Get.find<FontStyles>().poppinsMedium),
              SizedBox(width: 5),
              Text(
                '(${(value == 'take_away' || isFree) ? 'free'.tr : charge != -1 ? PriceConverter.convertPrice(charge) : 'calculating'.tr})',
                style: Get.find<FontStyles>().poppinsRegular,
              ),
            ],
          ),
        );
      },
    );
  }
}

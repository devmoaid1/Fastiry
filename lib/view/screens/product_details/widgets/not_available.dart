import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/product_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';

class ProductNotAvailableCard extends StatelessWidget {
  final Product product;
  const ProductNotAvailableCard({Key key, @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Theme.of(context).primaryColor.withOpacity(0.1),
      ),
      child: Column(children: [
        Text('not_available_now'.tr,
            style: Get.find<FontStyles>().poppinsMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),
        Text(
          '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(product.availableTimeStarts)} '
          '- ${DateConverter.convertTimeToTime(product.availableTimeEnds)}',
          style: Get.find<FontStyles>().poppinsRegular,
        ),
      ]),
    );
  }
}

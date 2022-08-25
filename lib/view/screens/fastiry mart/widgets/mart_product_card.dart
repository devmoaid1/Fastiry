import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/date_converter.dart';
import '../../../../helper/price_converter.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_image.dart';
import '../../../base/not_available_widget.dart';

class MartProductCard extends StatelessWidget {
  final Product product;
  const MartProductCard({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth * 0.45,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).disabledColor)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                child: CustomImage(
                  image:
                      '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                      '/${product.image}',
                  height: (Dimensions.screeHeight * 0.30) * 0.7,
                  width: Dimensions.screenWidth * 0.4,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            DateConverter.isAvailable(
                    product.availableTimeStarts, product.availableTimeEnds)
                ? SizedBox()
                : NotAvailableWidget(isRestaurant: false),
          ]),
          SizedBox(
            height: Dimensions.blockscreenVertical,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.blockscreenHorizontal,
                horizontal: Dimensions.blockscreenHorizontal * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 3.5),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(children: [
                  Text(
                    PriceConverter.convertPrice(product.price,
                        discount: product.discount,
                        discountType: product.discountType),
                    style: Get.find<FontStyles>().poppinsMedium.copyWith(
                        fontSize: Dimensions.blockscreenHorizontal * 4),
                  ),
                  SizedBox(
                      width: product.discount > 0
                          ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                          : 0),
                  product.discount > 0
                      ? Text(
                          PriceConverter.convertPrice(product.price),
                          style: Get.find<FontStyles>().poppinsRegular.copyWith(
                              fontSize: Dimensions.blockscreenHorizontal * 3.2,
                              color: Theme.of(context).dividerColor,
                              decorationThickness: 4,
                              decorationColor: Theme.of(context).disabledColor,
                              decoration: TextDecoration.lineThrough),
                        )
                      : SizedBox()
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}

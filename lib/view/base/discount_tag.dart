import '/controller/splash_controller.dart';
import '/helper/responsive_helper.dart';
import '/util/colors.dart';
import '/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';

class DiscountTag extends StatelessWidget {
  final double discount;
  final String discountType;
  final double fromTop;
  final double fontSize;
  final bool inLeft;
  final bool freeDelivery;
  DiscountTag({
    @required this.discount,
    @required this.discountType,
    this.fromTop = 10,
    this.fontSize,
    this.freeDelivery = false,
    this.inLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return (discount > 0 || freeDelivery)
        ? Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.blockscreenHorizontal * 2, vertical: 4),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? pink : Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(Dimensions.RADIUS_SMALL),
                left: Radius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.percent,
                    color: Colors.white,
                    size: Dimensions.blockscreenHorizontal * 3.5),
                SizedBox(width: 5),
                Text(
                  discount > 0
                      ? '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} ${'off'.tr}'
                      : 'free_delivery'.tr,
                  style: Get.find<FontStyles>().poppinsMedium.copyWith(
                        color: Colors.white,
                        fontSize: fontSize != null
                            ? fontSize
                            : ResponsiveHelper.isMobile(context)
                                ? Dimensions.blockscreenHorizontal * 3
                                : 12,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : SizedBox();
  }
}

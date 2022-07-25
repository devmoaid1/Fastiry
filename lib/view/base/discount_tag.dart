import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                Icon(Icons.percent, color: Colors.white, size: 15),
                SizedBox(width: 5),
                Text(
                  discount > 0
                      ? '$discount${discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} ${'off'.tr}'
                      : 'free_delivery'.tr,
                  style: poppinsMedium.copyWith(
                    color: Colors.white,
                    fontSize: fontSize != null
                        ? fontSize
                        : ResponsiveHelper.isMobile(context)
                            ? 10
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

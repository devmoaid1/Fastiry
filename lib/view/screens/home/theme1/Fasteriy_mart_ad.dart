import '/theme/font_styles.dart';
import '/util/dimensions.dart';
import '/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';

class FastriyMartAdSection extends StatelessWidget {
  const FastriyMartAdSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.blockscreenHorizontal * 2),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              // width: Dimensions.screenWidth * 0.48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Get.locale.languageCode != "en"
                            ? Image.asset(
                                Images.fastiryLogoTypeArabic,
                                height: Dimensions.blockscreenVertical * 6,
                                width: Dimensions.blockscreenVertical * 12,
                              )
                            : Container(),
                        Image.asset(
                          Images.fastiryLogoRed,
                          height: Dimensions.blockscreenVertical * 6,
                        ),
                        Get.locale.languageCode == "en"
                            ? Image.asset(
                                Images.fastiryLogoType,
                                height: Dimensions.blockscreenVertical * 6,
                                width: Dimensions.blockscreenVertical * 12,
                              )
                            : Container()
                      ],
                    ),
                  ),
                  Text("Groceries_home".tr,
                      style: Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 5,
                          color: Theme.of(context).primaryColor)),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                      onTap: () {
                        Get.toNamed(RouteHelper.getFastiryMartRoute());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.blockscreenVertical * 1.5,
                            horizontal: Dimensions.blockscreenHorizontal * 4),
                        child: Text(
                          'shop_now'.tr,
                          style: Get.find<FontStyles>()
                              .poppinsRegular
                              .copyWith(color: Colors.white),
                        ),
                      ))
                ],
              ),
            ),
          ),

          //graphics

          SizedBox(
            width: Dimensions.blockscreenHorizontal * 2,
          ),

          Expanded(
            flex: 1,
            child: Container(
              child: Image.asset(
                Images.fasteriyMartGraphics,
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}

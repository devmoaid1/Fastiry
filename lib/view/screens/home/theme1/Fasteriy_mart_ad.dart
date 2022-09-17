import 'package:efood_multivendor/theme/font_styles.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
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
                        // Container(
                        //   height: Dimensions.blockscreenVertical * 8,
                        //   child: Image.asset(
                        //     Images.fastiryLogoRed,
                        //     fit: BoxFit.fill,
                        //   ),
                        // ),
                        // Text("fasteriy".tr,
                        //     maxLines: 1,
                        //     style: Get.find<FontStyles>().poppinsRegular.copyWith(
                        //         fontSize: Dimensions.blockscreenHorizontal * 4.5,
                        //         color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                  Container(
                    child: Text("Groceries_home".tr,
                        textAlign: TextAlign.left,
                        style: Get.find<FontStyles>().poppinsMedium.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 5.5,
                            color: Theme.of(context).primaryColor)),
                  ),
                  Text("high_quality".tr,
                      style: Get.find<FontStyles>().poppinsMedium.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 4,
                          )),
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
              // height: Dimensions.blockscreenVertical * 20,
              // width: Dimensions.screenWidth * 0.45,
              child: Image.asset(
                Images.fasteriyMartGraphics,
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
    );
  }
}

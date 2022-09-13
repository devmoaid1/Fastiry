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
          vertical: 8, horizontal: Dimensions.blockscreenHorizontal * 2),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: Dimensions.blockscreenVertical * 10,
                    // width: Dimensions.screenWidth * 0.2,
                    child: Image.asset(
                      Images.fastiryLogoRed,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text("fasteriy_mart".tr,
                      maxLines: 1,
                      style: Get.find<FontStyles>().poppinsRegular.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 4.5,
                          color: Theme.of(context).primaryColor)),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: Dimensions.screenWidth * 0.6,
                    minHeight: Dimensions.screenWidth * 0.1),
                child: Text("Groceries_home".tr,
                    maxLines: 2,
                    style: Get.find<FontStyles>().poppinsMedium.copyWith(
                        fontSize: Dimensions.blockscreenHorizontal * 6,
                        color: Theme.of(context).primaryColor)),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: Dimensions.screenWidth * 0.7,
                    minHeight: Dimensions.screenWidth * 0.1),
                child: Text("high_quality".tr,
                    maxLines: 2,
                    style: Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 4,
                        )),
              ),
              // SizedBox(
              //   height: 5,
              // ),
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

          //graphics

          Container(
            height: Dimensions.blockscreenVertical * 20,
            width: Dimensions.screenWidth * 0.35,
            child: Image.asset(
              Images.fasteriyMartGraphics,
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }
}

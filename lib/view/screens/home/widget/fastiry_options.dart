import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/user_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import 'fastiry_option.dart';

class FastiryOptions extends StatelessWidget {
  const FastiryOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: Dimensions.blockscreenHorizontal * 55,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.blockscreenHorizontal * 3, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userController.userInfoModel != null &&
                          Get.find<AuthController>().isLoggedIn()
                      ? "${"hey".tr},${userController.userInfoModel.fName}"
                      : "hey_guest".tr,
                  style: Get.find<FontStyles>()
                      .poppinsMedium
                      .copyWith(fontSize: Dimensions.blockscreenHorizontal * 5),
                ),
                SizedBox(
                  height: Dimensions.blockscreenVertical * 2,
                ),
                Expanded(
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    FastiryOption(
                        imagePath: Images.fastiryFoodImage,
                        onTap: () {
                          Get.toNamed(RouteHelper.getFastiryFoodRoute());
                        },
                        optionName: "food".tr),
                    FastiryOption(
                        imagePath: Images.fastiryMartImage,
                        onTap: () {
                          Get.toNamed(RouteHelper.getFastiryMartRoute());
                        },
                        optionName: "fasteriy_mart".tr),
                  ]),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

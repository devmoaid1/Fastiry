import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/user_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import 'fastiry_option.dart';

class FastiryOptions extends StatelessWidget {
  const FastiryOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.blockscreenHorizontal * 5, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userController.userInfoModel != null &&
                        Get.find<AuthController>().isLoggedIn()
                    ? "${"hey".tr},${userController.userInfoModel.fName}"
                    : "hey_guest".tr,
                style: poppinsMedium.copyWith(
                    fontSize: Dimensions.blockscreenHorizontal * 5),
              ),
              SizedBox(
                height: Dimensions.blockscreenVertical * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FastiryOption(
                      imagePath: Images.breakFastImage,
                      onTap: () {
                        Get.toNamed(RouteHelper.getFastiryFoodRoute());
                      },
                      optionName: "food".tr),
                  FastiryOption(
                      imagePath: Images.breakFastImage,
                      onTap: () {
                        Get.toNamed(RouteHelper.getFastiryMartRoute());
                      },
                      optionName: "fasteriy_mart".tr),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}

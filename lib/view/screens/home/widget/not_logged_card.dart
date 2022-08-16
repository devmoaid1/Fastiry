import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/theme/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/dimensions.dart';

class NotLoggedCard extends StatelessWidget {
  const NotLoggedCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 9),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              !Get.isDarkMode ? Colors.grey[200] : Theme.of(context).cardColor,
        ),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.blockscreenVertical * 2,
            horizontal: Dimensions.blockscreenHorizontal * 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("hey_guest".tr,
                maxLines: 2,
                style: Get.find<FontStyles>()
                    .poppinsMedium
                    .copyWith(fontSize: Dimensions.blockscreenHorizontal * 5)),
            SizedBox(
              height: 10,
            ),
            Text("not_logged".tr,
                maxLines: 1,
                style: Get.find<FontStyles>()
                    .poppinsRegular
                    .copyWith(fontSize: Dimensions.blockscreenHorizontal * 3)),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.getSignInRoute('home'));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.blockscreenVertical * 1.5,
                    horizontal: Dimensions.blockscreenHorizontal * 4),
                child: Text(
                  'login_menu'.tr,
                  style: Get.find<FontStyles>()
                      .poppinsRegular
                      .copyWith(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

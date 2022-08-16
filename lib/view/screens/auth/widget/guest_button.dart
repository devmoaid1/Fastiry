import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';

class GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(
          context, RouteHelper.getInitialRoute()),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey[Get.isDarkMode ? 700 : 300],
                blurRadius: 1,
                spreadRadius: 0.5)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              style: BorderStyle.solid, width: 1, color: Colors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Images.user,
              width: 25,
              color: Colors.black,
            ),
            SizedBox(
              width: Dimensions.PADDING_SIZE_LARGE,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "guest_login".tr,
                style: Get.find<FontStyles>()
                    .poppinsRegular
                    .copyWith(color: Colors.black, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );

    // return TextButton(
    //   style: TextButton.styleFrom(
    //     minimumSize: Size(1, 40),
    //   ),
    //   onPressed: () {
    //     Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());
    //   },
    //   child: RichText(text: TextSpan(children: [
    //     TextSpan(text: '${'continue_as'.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
    //     TextSpan(text: 'guest'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyText1.color)),
    //   ])),
    // );
  }
}

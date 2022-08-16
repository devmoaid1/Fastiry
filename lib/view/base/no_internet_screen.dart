import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/services_instances.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';

class NoInternetScreen extends StatelessWidget {
  final Widget child;
  NoInternetScreen({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Images.no_internet,
                width: Dimensions.blockscreenHorizontal * 30,
                height: Dimensions.blockscreenHorizontal * 30),
            SizedBox(
              height: Dimensions.blockscreenVertical * 2,
            ),
            Text('oops'.tr,
                style: Get.find<FontStyles>().poppinsBold.copyWith(
                      fontSize: 30,
                      color: Theme.of(context).textTheme.bodyText1.color,
                    )),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Text(
              'no_internet_connection'.tr,
              textAlign: TextAlign.center,
              style: Get.find<FontStyles>()
                  .poppinsRegular
                  .copyWith(color: Theme.of(context).disabledColor),
            ),
            SizedBox(height: Dimensions.blockscreenVertical * 8),
            CustomButton(
              height: Dimensions.blockscreenVertical * 8,
              onPressed: () async {
                if (connectivityService.isConnected.isTrue) {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => child));
                }
              },
              buttonText: 'retry'.tr,
            ),
          ],
        ),
      ),
    );
  }
}

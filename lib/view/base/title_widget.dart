import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: Get.find<FontStyles>().poppinsMedium.copyWith(
                fontSize: Dimensions.blockscreenHorizontal * 5,
              )),
      (onTap != null && !ResponsiveHelper.isDesktop(context))
          ? InkWell(
              onTap: onTap,
              child: Text(
                'view_all'.tr,
                style: Get.find<FontStyles>().poppinsMedium.copyWith(
                    fontSize: Dimensions.blockscreenHorizontal * 3.5,
                    color: Theme.of(context).primaryColor),
              ),
            )
          : SizedBox(),
    ]);
  }
}

import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Function onTap;
  TitleWidget({@required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title,
          style: poppinsRegular.copyWith(
              fontSize: Dimensions.blockscreenHorizontal * 3.5,
              fontWeight: FontWeight.w600,
              color: lightGreyTextColor)),
      (onTap != null && !ResponsiveHelper.isDesktop(context))
          ? InkWell(
              onTap: onTap,
              child: Text(
                'view_all'.tr,
                style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).primaryColor),
              ),
            )
          : SizedBox(),
    ]);
  }
}

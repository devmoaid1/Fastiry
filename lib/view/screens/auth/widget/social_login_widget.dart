// import 'package:efood_multivendor/controller/auth_controller.dart';
// import 'package:efood_multivendor/controller/splash_controller.dart';
// import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
// import 'package:efood_multivendor/util/dimensions.dart';
// import 'package:efood_multivendor/util/images.dart';
// import 'package:efood_multivendor/util/styles.dart';
// import 'package:efood_multivendor/view/base/custom_snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class SocialLoginWidget extends StatelessWidget {
  final String iconPath;
  final Color color;
  final String title;
  final Color fontColor;
  final Color iconColor;
  final void Function() onTap;
  const SocialLoginWidget(
      {Key key,
      this.color = Colors.white,
      this.iconPath,
      this.title,
      this.fontColor,
      this.iconColor,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
            border: Border.all(
                style: BorderStyle.solid, width: 1, color: Colors.grey),
            color: color,
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              color: iconColor ?? null,
              width: 25,
            ),
            SizedBox(
              width: Dimensions.PADDING_SIZE_LARGE,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                title,
                style: poppinsRegular.copyWith(
                    color: this.fontColor, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}

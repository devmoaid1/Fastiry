import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final String text;
  NoDataScreen({@required this.text, this.isCart = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              isCart ? Images.empty_cart : Images.empty_box,
              width: MediaQuery.of(context).size.width * 0.22,
              height: MediaQuery.of(context).size.height * 0.22,
            ),
            SizedBox(height: Dimensions.blockscreenVertical * 3),
            Text(
              isCart ? 'cart_is_empty'.tr : text,
              style: Get.find<FontStyles>().poppinsMedium.copyWith(
                  fontSize: Dimensions.blockscreenHorizontal * 3.5,
                  color: Theme.of(context).dividerColor),
              textAlign: TextAlign.center,
            ),
          ]),
    );
  }
}

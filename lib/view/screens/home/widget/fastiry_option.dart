import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';

class FastiryOption extends StatelessWidget {
  final void Function() onTap;
  final String optionName;
  final String imagePath;
  const FastiryOption(
      {Key key,
      @required this.imagePath,
      @required this.onTap,
      @required this.optionName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(right: Dimensions.blockscreenHorizontal * 1),
          // width: Dimensions.screenWidth * 0.4,
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  !Get.isDarkMode
                      ? BoxShadow(
                          color: Colors.grey[200],
                          offset: Offset(0, 3),
                          spreadRadius: 0.4,
                          blurRadius: 7)
                      : BoxShadow(color: Theme.of(context).backgroundColor)
                ],
              ),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: Dimensions.screenWidth * 0.45,
                  height: Dimensions.blockscreenHorizontal * 25,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: Dimensions.blockscreenVertical * 1.5,
              ),
              child: Text(
                optionName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Get.locale.languageCode != "en"
                    ? Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 3.8,
                        )
                    : Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 3.6,
                        ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

import '/util/colors.dart';
import '/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/font_styles.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets margin;
  final double height;
  final double width;
  final double fontSize;
  final double radius;
  final IconData icon;
  final Color iconColor;
  CustomButton(
      {this.onPressed,
      @required this.buttonText,
      this.transparent = false,
      this.iconColor = lightGreyTextColor,
      this.margin,
      this.width,
      this.height,
      this.fontSize,
      this.radius = 5,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle _flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width : Dimensions.WEB_MAX_WIDTH,
          height != null ? height : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    return Center(
        child: SizedBox(
            width: width != null ? width : Dimensions.WEB_MAX_WIDTH,
            child: Padding(
              padding: margin == null ? EdgeInsets.all(0) : margin,
              child: TextButton(
                onPressed: onPressed,
                style: _flatButtonStyle,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  icon != null
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: Icon(icon,
                              color: transparent
                                  ? Theme.of(context).primaryColor
                                  : iconColor),
                        )
                      : SizedBox(),
                  Text(buttonText ?? '',
                      textAlign: TextAlign.center,
                      style: Get.find<FontStyles>().poppinsRegular.copyWith(
                            color: transparent
                                ? Theme.of(context).primaryColor
                                : Colors.white,
                            fontSize: fontSize != null
                                ? fontSize
                                : Dimensions.fontSizeLarge,
                          )),
                ]),
              ),
            )));
  }
}

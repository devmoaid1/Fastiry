import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileButton extends StatelessWidget {
  final String iconPath;

  final String title;
  final bool isButtonActive;
  final Function onTap;
  ProfileButton(
      {@required this.title,
      @required this.onTap,
      this.iconPath,
      this.isButtonActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_SMALL,
            vertical: isButtonActive != null
                ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                : Dimensions.PADDING_SIZE_DEFAULT,
          ),
          child: Row(children: [
            SvgPicture.asset(
              iconPath,
              color: lightGreyTextColor,
              width: 27,
              height: 27,
            ),
            SizedBox(width: Dimensions.blockscreenHorizontal * 4),
            Expanded(
                child: Text(title,
                    style: poppinsRegular.copyWith(color: lightGreyTextColor))),
            isButtonActive != null
                ? Switch(
                    value: isButtonActive,
                    onChanged: (bool isActive) => onTap(),
                    activeColor: Theme.of(context).primaryColor,
                    activeTrackColor:
                        Theme.of(context).primaryColor.withOpacity(0.5),
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}

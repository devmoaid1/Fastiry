import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:flutter/cupertino.dart';
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
              color: Theme.of(context).dividerColor,
              width: Dimensions.blockscreenHorizontal * 6,
              height: Dimensions.blockscreenHorizontal * 6,
            ),
            SizedBox(width: Dimensions.blockscreenHorizontal * 4),
            Expanded(
                child: Text(title,
                    style: poppinsRegular.copyWith(
                        color: Theme.of(context).dividerColor))),
            isButtonActive != null
                ? CupertinoSwitch(
                    value: isButtonActive,
                    trackColor: Theme.of(context).dividerColor.withOpacity(0.4),
                    onChanged: (bool isActive) => onTap(),
                    activeColor: Theme.of(context).primaryColor,
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}

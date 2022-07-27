import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../util/colors.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class MenuSelection extends StatelessWidget {
  final String iconPath;
  final String label;
  final void Function() onTap;
  const MenuSelection({Key key, this.iconPath, this.label, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SvgPicture.asset(
        iconPath,
        color: lightGreyTextColor,
        height: 27,
        width: 27,
      ),
      title: Text(
        label,
        style: poppinsRegular.copyWith(
            fontSize: Dimensions.blockscreenHorizontal * 4,
            color: lightGreyTextColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: lightGreyTextColor,
        size: 23,
      ),
    );
  }
}
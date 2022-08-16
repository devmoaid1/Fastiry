import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';

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
        color: Theme.of(context).dividerColor,
        height: 27,
        width: 27,
      ),
      title: Text(
        label,
        style: Get.find<FontStyles>().poppinsRegular.copyWith(
            fontSize: Dimensions.blockscreenHorizontal * 4,
            color: Theme.of(context).dividerColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Theme.of(context).dividerColor,
        size: 23,
      ),
    );
  }
}

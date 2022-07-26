import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavItem extends StatelessWidget {
  final String iconPath;
  final String iconName;
  final IconData iconData;
  final Function onTap;
  final bool isSelected;
  BottomNavItem(
      {@required this.iconData,
      this.iconPath,
      this.iconName,
      this.onTap,
      this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
      height: 25,
      width: 25,
    );
  }
}

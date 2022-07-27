import 'package:efood_multivendor/util/colors.dart';
import 'package:efood_multivendor/util/dimensions.dart';

import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import './widget/menu_item.dart';
import '../../../util/images.dart';

class MenuScreenNew extends StatelessWidget {
  const MenuScreenNew({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Menu', isBackButtonExist: false),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.blockscreenVertical * 2,
            horizontal: Dimensions.blockscreenHorizontal * 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MenuSelection(
                iconPath: Images.profileIcon,
                label: 'Profile',
                onTap: () {},
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.settingsIcon,
                label: 'Settings',
                onTap: () {},
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.languageIcon,
                label: 'Language',
                onTap: () {},
              ),
              MenuDivider(),
              MenuSelection(
                iconPath: Images.notificationIcon,
                label: 'Notification',
                onTap: () {},
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class MenuDivider extends StatelessWidget {
  const MenuDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.blockscreenVertical * 2,
          horizontal: Dimensions.blockscreenHorizontal * 3),
      child: Divider(
        color: lightGreyTextColor,
        thickness: 0.3,
        height: 1,
      ),
    );
  }
}

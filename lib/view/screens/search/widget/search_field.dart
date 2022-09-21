import '/util/colors.dart';
import '/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final Function iconPressed;
  final Function onSubmit;
  final Function onChanged;
  SearchField(
      {@required this.controller,
      @required this.hint,
      @required this.suffixIcon,
      @required this.iconPressed,
      this.onSubmit,
      this.onChanged});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      style: Get.find<FontStyles>().poppinsRegular.copyWith(
            color: Get.isDarkMode
                ? Theme.of(context).cardColor
                : Theme.of(context).dividerColor,
          ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: Get.find<FontStyles>().poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: offWhite,
        isDense: true,
        suffixIcon: IconButton(
          onPressed: widget.iconPressed,
          color: Get.isDarkMode
              ? Theme.of(context).cardColor
              : Theme.of(context).dividerColor,
          icon: Icon(widget.suffixIcon),
        ),
      ),
      onSubmitted: widget.onSubmit,
      onChanged: widget.onChanged,
    );
  }
}

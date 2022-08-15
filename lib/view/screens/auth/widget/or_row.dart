import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';

class OrRow extends StatelessWidget {
  const OrRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_LARGE,
          vertical: Dimensions.PADDING_SIZE_SMALL),
      child: Row(children: <Widget>[
        Expanded(
          child: Divider(color: Theme.of(context).dividerColor),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "OR",
            style: Get.find<FontStyles>().poppinsRegular,
          ),
        ),
        Expanded(
            child: Divider(
          color: Theme.of(context).dividerColor,
        )),
      ]),
    );
  }
}

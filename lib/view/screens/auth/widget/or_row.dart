import 'package:flutter/material.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class OrRow extends StatelessWidget {
  const OrRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_LARGE,
          vertical: Dimensions.PADDING_SIZE_SMALL),
      child: Row(children: <Widget>[
        const Expanded(
          child: Divider(color: Color(0xff5C5C5F)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "OR",
            style: poppinsRegular,
          ),
        ),
        const Expanded(
            child: Divider(
          color: Colors.black,
        )),
      ]),
    );
  }
}

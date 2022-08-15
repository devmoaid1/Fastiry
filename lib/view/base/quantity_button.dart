import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final bool canDecrement;
  final Function onTap;
  final bool fromProductPage;
  QuantityButton(
      {@required this.isIncrement,
      @required this.onTap,
      @required this.fromProductPage,
      this.canDecrement = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        alignment: Alignment.center,
        child: canDecrement
            ? Icon(isIncrement ? Icons.add : Icons.remove,
                size: 27, color: Theme.of(context).primaryColor
                // : Theme.of(context).primaryColor.withOpacity(0.4),
                )
            : !fromProductPage
                ? SvgPicture.asset(
                    Images.trashIcon,
                    color: Theme.of(context).primaryColor,
                    width: 20,
                    height: 20,
                  )
                : Icon(Icons.remove,
                    size: 27,
                    color: Theme.of(context).primaryColor.withOpacity(0.4)
                    // : Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
      ),
    );
  }
}

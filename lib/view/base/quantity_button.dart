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
      child: canDecrement
          ? Icon(isIncrement ? Icons.add : Icons.remove,
              size: 25, color: Theme.of(context).primaryColor
              // : Theme.of(context).primaryColor.withOpacity(0.4),
              )
          : !fromProductPage
              ? SvgPicture.asset(
                  Images.trashIcon,
                  color: Theme.of(context).primaryColor,
                  width: 18,
                  height: 18,
                )
              : Icon(Icons.remove,
                  size: 25,
                  color: Theme.of(context).primaryColor.withOpacity(0.4)
                  // : Theme.of(context).primaryColor.withOpacity(0.4),
                  ),
    );
  }
}

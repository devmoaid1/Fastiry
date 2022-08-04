import 'package:efood_multivendor/util/dimensions.dart';
import 'package:flutter/material.dart';

class QuantityButton extends StatelessWidget {
  final bool isIncrement;
  final bool canDecrement;
  final Function onTap;
  QuantityButton(
      {@required this.isIncrement,
      @required this.onTap,
      this.canDecrement = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
        alignment: Alignment.center,
        child: Icon(
          isIncrement ? Icons.add : Icons.remove,
          size: 20,
          color: canDecrement
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColor.withOpacity(0.4),
        ),
      ),
    );
  }
}

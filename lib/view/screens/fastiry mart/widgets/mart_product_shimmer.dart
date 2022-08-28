import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../util/dimensions.dart';

class MartProductShimmer extends StatelessWidget {
  final int index;
  final CategoryController categoryController;
  const MartProductShimmer(
      {Key key, @required this.categoryController, @required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        width: Dimensions.screenWidth * 0.4,
        height: (Dimensions.screeHeight * 0.30) * 0.7,
        color: Colors.grey[300],
        margin: EdgeInsets.only(
          left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
          right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: categoryController.subCategoryList == null,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            ),
          ),
        ),
      ),
    );
  }
}

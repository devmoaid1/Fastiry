import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../util/dimensions.dart';

class MartCategoryShimmer extends StatelessWidget {
  final int index;
  final CategoryController categoryController;
  const MartCategoryShimmer(
      {Key key, @required this.index, @required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Container(
        color: Theme.of(context).cardColor,
        margin: EdgeInsets.only(
          left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
          right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
        ),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: categoryController.subCategoryList == null,
          child: Container(
            height: Dimensions.blockscreenVertical * 22,
            width: Dimensions.blockscreenHorizontal * 35,
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

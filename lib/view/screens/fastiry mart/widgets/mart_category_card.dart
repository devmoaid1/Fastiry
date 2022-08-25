import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';

class MartCategoryCard extends StatelessWidget {
  final CategoryModel category;
  const MartCategoryCard({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              Images.breakFastImage,
              fit: BoxFit.fill,
              height: Dimensions.blockscreenVertical * 10,
              //
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: Get.find<FontStyles>().poppinsRegular,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}

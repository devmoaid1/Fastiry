import 'package:efood_multivendor/data/model/response/review_model.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/font_styles.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool hasDivider;
  final String resturantName;
  ReviewWidget(
      {@required this.review,
      @required this.hasDivider,
      @required this.resturantName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          ClipOval(
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                Images.profilePlaceholder,
                height: Dimensions.blockscreenVertical * 8,
                width: Dimensions.blockscreenVertical * 8,
                fit: BoxFit.fill,
              )),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  review.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.find<FontStyles>()
                      .poppinsBold
                      .copyWith(fontSize: Dimensions.blockscreenHorizontal * 4),
                ),
                Text(
                  resturantName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                      fontSize: Dimensions.blockscreenHorizontal * 3.5,
                      color: Theme.of(context).disabledColor),
                ),
                Row(
                  children: [
                    RatingBar(
                        rating: review.rating.toDouble(),
                        ratingCount: null,
                        size: 15),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      review.createdAt,
                      style: Get.find<FontStyles>().poppinsRegular.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 3,
                          color: Theme.of(context).disabledColor),
                    )
                  ],
                ),
              ])),
        ]),
        SizedBox(
          height: Dimensions.blockscreenVertical * 4,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(review.comment,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Get.find<FontStyles>().poppinsRegular.copyWith(
                    fontSize: Dimensions.blockscreenHorizontal * 4,
                  )),
        ),
        Divider(color: Theme.of(context).disabledColor)
      ]),
    );
  }
}

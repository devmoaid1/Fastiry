import '/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/restaurant_model.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../restaurant_viewModel.dart';

class CategoriesSelection extends StatelessWidget {
  final RestuarantViewModel restaurantViewModel;
  final Restaurant restaurant;
  const CategoriesSelection(
      {Key key, @required this.restaurant, @required this.restaurantViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SliverDelegate(
          child: Container(
        height: 80,
        width: Dimensions.WEB_MAX_WIDTH,
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.blockscreenVertical, horizontal: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          key: UniqueKey(),
          itemCount: restaurantViewModel.restaurantCategories.length,
          padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final category = restaurantViewModel.restaurantCategories[index];
            return InkWell(
              onTap: () =>
                  restaurantViewModel.setCategoryIndex(index, category.id),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.blockscreenVertical,
                    horizontal: Dimensions.blockscreenHorizontal),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: index == restaurantViewModel.categoryIndex
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).backgroundColor,
                            width: 2))),
                child: Text(
                  category.name,
                  style: index == restaurantViewModel.categoryIndex
                      ? Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor)
                      : Get.find<FontStyles>().poppinsRegular.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).disabledColor),
                ),
              ),
            );
          },
        ),
      )),
    );
  }
}

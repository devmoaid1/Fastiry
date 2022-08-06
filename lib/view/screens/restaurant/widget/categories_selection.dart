import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';

import '../../../../controller/restaurant_controller.dart';
import '../../../../data/model/response/restaurant_model.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class CategoriesSelection extends StatelessWidget {
  final RestaurantController restaurantController;
  final Restaurant restaurant;
  const CategoriesSelection(
      {Key key, @required this.restaurant, @required this.restaurantController})
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
          itemCount: restaurantController.categoryList.length,
          padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => restaurantController.setCategoryIndex(index),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.blockscreenVertical,
                    horizontal: Dimensions.blockscreenHorizontal),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: index == restaurantController.categoryIndex
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).backgroundColor,
                            width: 2))),
                child: Text(
                  restaurantController.categoryList[index].name,
                  style: index == restaurantController.categoryIndex
                      ? poppinsMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor)
                      : poppinsRegular.copyWith(
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

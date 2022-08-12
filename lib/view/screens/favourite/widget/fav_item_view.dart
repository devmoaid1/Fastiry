import 'package:efood_multivendor/controller/wishlist_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavItemView extends StatelessWidget {
  final bool isRestaurant;
  FavItemView({@required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<WishListController>(builder: (wishController) {
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child: isRestaurant && wishController.wishRestList.isNotEmpty ||
                      wishController.wishProductList.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.blockscreenVertical * 2,
                          horizontal: Dimensions.blockscreenHorizontal * 2),
                      itemCount: isRestaurant
                          ? wishController.wishRestList.length
                          : wishController.wishProductList.length,
                      itemBuilder: (context, index) {
                        return isRestaurant
                            ? ProductWidget(
                                product: null,
                                isRestaurant: isRestaurant,
                                restaurant: wishController.wishRestList[index],
                                index: index,
                                length: wishController.wishRestList.length ?? 0)
                            : ProductWidget(
                                product: wishController.wishProductList[index],
                                isRestaurant: isRestaurant,
                                restaurant: null,
                                index: index,
                                length:
                                    wishController.wishProductList.length ?? 0);
                      },
                    )
                  : NoDataScreen(text: 'no_data_found'.tr)),
        );
      }),
    );
  }
}

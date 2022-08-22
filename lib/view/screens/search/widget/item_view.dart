import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/no_data_screen.dart';

class ItemView extends StatelessWidget {
  final bool isRestaurant;
  ItemView({@required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GetBuilder<SearchController>(builder: (searchController) {
        if (!searchController.isLoading) {
          if (!isRestaurant && searchController.searchProductList.isEmpty) {
            return Center(
              child: NoDataScreen(text: "no_food_available".tr),
            );
          } else if (isRestaurant && searchController.searchRestList.isEmpty) {
            return Center(
              child: NoDataScreen(text: 'no_restaurant_available'.tr),
            );
          } else {
            return ListView.builder(
                itemCount: isRestaurant
                    ? searchController.searchRestList.length
                    : searchController.searchProductList.length,
                itemBuilder: (context, index) {
                  return isRestaurant
                      ? ProductWidget(
                          isRestaurant: isRestaurant,
                          restaurant: searchController.searchRestList[index],
                          product: null,
                          index: index,
                          length: searchController.searchRestList.isNotEmpty
                              ? searchController.searchRestList.length
                              : 0,
                          inRestaurant: true,
                          isCampaign: false,
                        )
                      : ProductWidget(
                          isRestaurant: isRestaurant,
                          restaurant: null,
                          product: searchController.searchProductList[index],
                          index: index,
                          length: searchController.searchProductList.isNotEmpty
                              ? searchController.searchProductList.length
                              : 0,
                          inRestaurant: true,
                          isCampaign: false,
                          // products: searchController.searchProductList,
                          // restaurants: searchController.searchRestList,
                        );
                });
          }
        }
        return Center(
          child: CustomLoader(),
        );
      }),
    );
  }
}

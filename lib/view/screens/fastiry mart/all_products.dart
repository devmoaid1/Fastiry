import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/category_controller.dart';
import '../../base/product_widget.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: "all_products".tr),
      body: SafeArea(
          child: GetBuilder<CategoryController>(
        builder: (categoryController) => ListView.builder(
            itemCount: categoryController.categoryProductList != null
                ? categoryController.categoryProductList.length
                : 10,
            itemBuilder: (context, index) {
              return ProductWidget(
                  product: categoryController.categoryProductList[index],
                  isRestaurant: false,
                  inRestaurant: true,
                  restaurant: null,
                  index: index,
                  length: categoryController.categoryProductList.length);
            }),
      )),
    );
  }
}

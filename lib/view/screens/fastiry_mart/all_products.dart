import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/response/product_model.dart';
import '../../base/product_widget.dart';

class AllProductsScreen extends StatelessWidget {
  final List<Product> products;
  const AllProductsScreen({
    @required this.products,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: "all_products".tr),
      body: SafeArea(
        child: products.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.symmetric(
                    vertical: Dimensions.blockscreenVertical * 2),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductWidget(
                      product: products[index],
                      isRestaurant: false,
                      inRestaurant: true,
                      restaurant: null,
                      index: index,
                      length: products.length);
                })
            : Center(
                child: NoDataScreen(text: "no_food_available".tr),
              ),
      ),
    );
  }
}

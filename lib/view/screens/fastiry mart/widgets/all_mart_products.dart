import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/mart_product_card.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/mart_product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../base/title_widget.dart';

class AllMartProductsSection extends StatelessWidget {
  final CategoryController categoryController;
  const AllMartProductsSection({Key key, @required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.blockscreenVertical * 3,
              horizontal: Dimensions.blockscreenHorizontal * 4),
          child: TitleWidget(
              title: 'all_products'.tr,
              onTap: () => Get.toNamed(RouteHelper.getAllProductsRoute())),
        ),
        SizedBox(
          height: Dimensions.screeHeight * 0.50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryController.categoryProductList != null
                  ? categoryController.categoryProductList.length
                  : 4,
              itemBuilder: ((context, index) {
                if (categoryController.categoryProductList != null) {
                  if (categoryController.categoryProductList.isNotEmpty) {
                    final product =
                        categoryController.categoryProductList[index];
                    return MartProductCard(product: product);
                  }

                  return Center(
                      child: NoDataScreen(text: "No Products at the moment"));
                }

                return MartProductShimmer(
                    categoryController: categoryController, index: index);
              })),
        )
      ],
    );
  }
}

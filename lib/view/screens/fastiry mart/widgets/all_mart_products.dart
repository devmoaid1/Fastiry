import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/mart_viewModel.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/mart_product_card.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/mart_product_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../base/title_widget.dart';

class AllMartProductsSection extends StatelessWidget {
  final MartViewModel martViewModel;
  const AllMartProductsSection({Key key, @required this.martViewModel})
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
              onTap: () => Get.toNamed(RouteHelper.getAllProductsRoute(),
                  arguments: martViewModel.martProducts ?? [])),
        ),
        SizedBox(
          height: Dimensions.screeHeight * 0.50,
          child: !martViewModel.isLoading
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: martViewModel.martProducts.length,
                  // itemCount: categoryController.categoryProductList != null
                  //     ? categoryController.categoryProductList.length
                  //     : 4,
                  itemBuilder: ((context, index) {
                    if (martViewModel.martProducts.isNotEmpty) {
                      final product = martViewModel.martProducts[index];
                      return MartProductCard(product: product);
                    }

                    return Center(
                        child: NoDataScreen(text: "No Products at the moment"));
                  }))
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: ((context, index) {
                    return MartProductShimmer(
                        martViewModel: martViewModel, index: index);
                  })),
        )
      ],
    );
  }
}

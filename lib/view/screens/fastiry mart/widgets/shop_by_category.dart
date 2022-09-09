import 'package:efood_multivendor/view/screens/fastiry%20mart/mart_viewModel.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/mart_category_card.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/widgets/mart_category_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../base/title_widget.dart';

class ShopByCategorySection extends StatelessWidget {
  final MartViewModel martViewModel;
  const ShopByCategorySection({Key key, @required this.martViewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.blockscreenVertical * 3,
            horizontal: Dimensions.blockscreenHorizontal * 4),
        child: TitleWidget(
            title: 'shop_by_category'.tr,
            onTap: () => Get.toNamed(RouteHelper.getCategoryRoute(true))),
      ),
      SizedBox(
          height: martViewModel.martCategories != null
              ? martViewModel.martCategories.length <= 4
                  ? Dimensions.screeHeight * 0.19
                  : Dimensions.screeHeight * 0.35
              : 0,
          child: !martViewModel.isLoading
              ? GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.blockscreenHorizontal * 2),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.PADDING_SIZE_LARGE
                        : 0.01,
                    childAspectRatio: Get.locale.languageCode == "en"
                        ? Dimensions.blockscreenHorizontal / 6.9
                        : Dimensions.blockscreenHorizontal / 6.4,
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : 3,
                  ),
                  itemCount: martViewModel.martCategories.length,
                  itemBuilder: (context, index) {
                    final category = martViewModel.martCategories[index];
                    return MartCategoryCard(category: category);
                    // return MartCategoryShimmer(
                    //     index: index, martViewModel: martViewModel);
                  })
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.blockscreenHorizontal * 2),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                    mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                        ? Dimensions.PADDING_SIZE_LARGE
                        : 0.01,
                    childAspectRatio: Get.locale.languageCode == "en"
                        ? Dimensions.blockscreenHorizontal / 6.9
                        : Dimensions.blockscreenHorizontal / 6.4,
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : 3,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return MartCategoryShimmer(
                        index: index, martViewModel: martViewModel);
                  }))
    ]);
  }
}

import '/controller/product_controller.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

class PopularFoodScreen extends StatefulWidget {
  final bool isPopular;
  PopularFoodScreen({@required this.isPopular});

  @override
  State<PopularFoodScreen> createState() => _PopularFoodScreenState();
}

class _PopularFoodScreenState extends State<PopularFoodScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.isPopular) {
      Get.find<ProductController>().getPopularProductList(
          true, Get.find<ProductController>().popularType, false);
    } else {
      Get.find<ProductController>().getReviewedProductList(
          true, Get.find<ProductController>().reviewType, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: widget.isPopular
            ? 'popular_foods_nearby'.tr
            : 'best_reviewed_food'.tr,
        showCart: false,
        isWithLogo: true,
      ),
      body: Scrollbar(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.blockscreenVertical * 4,
                horizontal: Dimensions.blockscreenHorizontal * 2),
            child: Text(
              widget.isPopular
                  ? 'popular_foods_nearby'.tr
                  : 'best_reviewed_food'.tr,
              style: Get.find<FontStyles>()
                  .poppinsMedium
                  .copyWith(fontSize: Dimensions.blockscreenHorizontal * 5),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: Dimensions.WEB_MAX_WIDTH,
              child:
                  GetBuilder<ProductController>(builder: (productController) {
                return productController.popularProductList != null &&
                        productController.reviewedProductList != null
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                              product:
                                  productController.popularProductList[index],
                              isRestaurant: false,
                              restaurant: null,
                              index: index,
                              isCampaign: false,
                              inRestaurant: true,
                              length:
                                  productController.popularProductList.length);
                        },
                        itemCount: widget.isPopular
                            ? productController.popularProductList.length
                            : productController.reviewedProductList.length,
                      )
                    : Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                // return ProductView(
                //   inRestaurantPage: true,
                //   isRestaurant: false
                //   restaurants: null,
                //   type: widget.isPopular
                //       ? productController.popularType
                //       : productController.reviewType,
                //   products: widget.isPopular
                //       ? productController.popularProductList
                //       : productController.reviewedProductList,
                //   onVegFilterTap: (String type) {
                //     if (widget.isPopular) {
                //       productController.getPopularProductList(true, type, true);
                //     } else {
                //       productController.getReviewedProductList(true, type, true);
                //     }
                //   },
                // );
              }),
            ),
          ),
        ],
      )),
    );
  }
}

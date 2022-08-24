import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../controller/category_controller.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/title_widget.dart';

class ShopByCategorySection extends StatelessWidget {
  const ShopByCategorySection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: Dimensions.blockscreenVertical * 3,
              horizontal: Dimensions.blockscreenHorizontal * 4),
          child: TitleWidget(
              title: 'shop_by_category'.tr,
              onTap: () => Get.toNamed(RouteHelper.getCategoryRoute(true))),
        ),
        GetBuilder<CategoryController>(builder: (categoryController) {
          return SizedBox(
            height: Dimensions.screeHeight * 0.20,
            child: GridView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.blockscreenHorizontal * 2),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                  mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                      ? Dimensions.PADDING_SIZE_LARGE
                      : 0.01,
                  childAspectRatio: Dimensions.blockscreenHorizontal / 6,
                  crossAxisCount: ResponsiveHelper.isMobile(context) ? 4 : 3,
                ),
                itemCount: categoryController.subCategoryList != null
                    ? categoryController.subCategoryList.length
                    : 4,
                itemBuilder: (context, index) {
                  if (categoryController.subCategoryList == null) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: Container(
                        color: Theme.of(context).cardColor,
                        margin: EdgeInsets.only(
                          left: index == 0
                              ? 0
                              : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        ),
                        child: Shimmer(
                          duration: Duration(seconds: 2),
                          enabled: categoryController.subCategoryList == null,
                          child: Container(
                            height: Dimensions.blockscreenVertical * 22,
                            width: Dimensions.blockscreenHorizontal * 35,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    final category = categoryController.subCategoryList[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              Images.breakFastImage,
                              fit: BoxFit.fill,
                              height: Dimensions.blockscreenVertical * 10,
                              //
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: Get.find<FontStyles>().poppinsRegular,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    );
                  }
                }),
          );
        })
      ],
    );
  }
}

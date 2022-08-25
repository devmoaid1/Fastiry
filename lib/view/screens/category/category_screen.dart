import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../theme/font_styles.dart';

class CategoryScreen extends StatefulWidget {
  bool fromMartScreen;

  CategoryScreen({@required this.fromMartScreen});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.fromMartScreen) {
      Get.find<CategoryController>().getSubCategoryList("15");
    }
    Get.find<CategoryController>().getCategoryList(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
        title: 'categories'.tr,
        isWithLogo: true,
        isWithSpace: true,
      ),
      body: SafeArea(
          child: Scrollbar(
              child: SingleChildScrollView(
                  child: SizedBox(
        width: Dimensions.WEB_MAX_WIDTH,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.blockscreenVertical * 2,
                  horizontal: Dimensions.blockscreenHorizontal * 3),
              child: Text(
                "categories".tr,
                style: Get.find<FontStyles>()
                    .poppinsMedium
                    .copyWith(fontSize: Dimensions.blockscreenHorizontal * 5),
              ),
            ),
            GetBuilder<CategoryController>(builder: (catController) {
              if (widget.fromMartScreen) {
                return catController.subCategoryList != null
                    ? catController.subCategoryList.length > 0
                        ? GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 6
                                      : ResponsiveHelper.isTab(context)
                                          ? 4
                                          : 3,
                              childAspectRatio: Get.locale.languageCode == "en"
                                  ? Dimensions.blockscreenHorizontal / 6.8
                                  : Dimensions.blockscreenHorizontal / 6.2,
                              mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                              crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: catController.subCategoryList.length,
                            itemBuilder: (context, index) {
                              return CategoryCard(
                                  category:
                                      catController.subCategoryList[index]);
                            },
                          )
                        : NoDataScreen(text: 'no_category_found'.tr)
                    : GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context)
                              ? 6
                              : ResponsiveHelper.isTab(context)
                                  ? 4
                                  : 3,
                          childAspectRatio: Get.locale.languageCode == "en"
                              ? Dimensions.blockscreenHorizontal / 6.9
                              : Dimensions.blockscreenHorizontal / 6,
                          mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                          crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                        ),
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        itemCount: 6,
                        itemBuilder: (context, index) {
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
                                enabled: catController.subCategoryList == null,
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
                        },
                      );
              } else {
                return catController.categoryList != null
                    ? catController.categoryList.length > 0
                        ? GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 6
                                      : ResponsiveHelper.isTab(context)
                                          ? 4
                                          : 3,
                              childAspectRatio:
                                  Dimensions.blockscreenHorizontal / 6,
                              mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                              crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                            ),
                            padding:
                                EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            itemCount: catController.categoryList.length,
                            itemBuilder: (context, index) {
                              final category =
                                  catController.categoryList[index];
                              if (category.name == "Grocery" ||
                                  category.name == "بقالة") {
                                return SizedBox();
                              }
                              return CategoryCard(category: category);
                            },
                          )
                        : NoDataScreen(text: 'no_category_found'.tr)
                    : Center(child: CircularProgressIndicator());
              }
            }),
          ],
        ),
      )))),
    );
  }
}

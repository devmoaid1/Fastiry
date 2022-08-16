import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();

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
              return catController.categoryList != null
                  ? catController.categoryList.length > 0
                      ? GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: ResponsiveHelper.isDesktop(context)
                                ? 6
                                : ResponsiveHelper.isTab(context)
                                    ? 4
                                    : 3,
                            childAspectRatio:
                                Dimensions.blockscreenHorizontal / 5,
                            mainAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                            crossAxisSpacing: Dimensions.PADDING_SIZE_SMALL,
                          ),
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          itemCount: catController.categoryList.length,
                          itemBuilder: (context, index) {
                            return CategoryCard(
                                category: catController.categoryList[index]);
                          },
                        )
                      : NoDataScreen(text: 'no_category_found'.tr)
                  : Center(child: CircularProgressIndicator());
            }),
          ],
        ),
      )))),
    );
  }
}

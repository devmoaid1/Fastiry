import '/controller/category_controller.dart';
import '/helper/responsive_helper.dart';
import '/theme/font_styles.dart';
import '/util/dimensions.dart';
import '/view/base/custom_loader.dart';
import '/view/base/no_data_screen.dart';
import '/view/base/web_menu_bar.dart';
import '/view/screens/category/category_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/product_widget.dart';

class CategoryProductScreen extends StatefulWidget {
  final String categoryID;
  final String categoryName;
  CategoryProductScreen(
      {@required this.categoryID, @required this.categoryName});

  @override
  _CategoryProductScreenState createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen>
    with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final ScrollController restaurantScrollController = ScrollController();
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CategoryViewModel>().initCategoryScreen(widget.categoryID);
    });
    // _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    // Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    // scrollController?.addListener(() {
    //   if (scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent &&
    //       Get.find<CategoryController>().categoryProductList != null &&
    //       !Get.find<CategoryController>().isLoading) {
    //     int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
    //     if (Get.find<CategoryController>().offset < pageSize) {
    //       print('end of the page');
    //       Get.find<CategoryController>().showBottomLoader();
    //       Get.find<CategoryController>().getCategoryProductList(
    //         Get.find<CategoryController>().subCategoryIndex == 0
    //             ? widget.categoryID
    //             : Get.find<CategoryController>()
    //                 .subCategoryList[
    //                     Get.find<CategoryController>().subCategoryIndex]
    //                 .id
    //                 .toString(),
    //         Get.find<CategoryController>().offset + 1,
    //         Get.find<CategoryController>().type,
    //         false,
    //       );
    //     }
    //   }
    // });
    // restaurantScrollController?.addListener(() {
    //   if (scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent &&
    //       Get.find<CategoryController>().categoryRestList != null &&
    //       !Get.find<CategoryController>().isLoading) {
    //     int pageSize =
    //         (Get.find<CategoryController>().restPageSize / 10).ceil();
    //     if (Get.find<CategoryController>().offset < pageSize) {
    //       print('end of the page');
    //       Get.find<CategoryController>().showBottomLoader();
    //       Get.find<CategoryController>().getCategoryRestaurantList(
    //         Get.find<CategoryController>().subCategoryIndex == 0
    //             ? widget.categoryID
    //             : Get.find<CategoryController>()
    //                 .subCategoryList[
    //                     Get.find<CategoryController>().subCategoryIndex]
    //                 .id
    //                 .toString(),
    //         Get.find<CategoryController>().offset + 1,
    //         Get.find<CategoryController>().type,
    //         false,
    //       );
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      return WillPopScope(
        onWillPop: () async {
          if (categoryController.isSearching) {
            categoryController.toggleSearch();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: ResponsiveHelper.isDesktop(context)
              ? WebMenuBar()
              : AppBar(
                  title: categoryController.isSearching
                      ? TextField(
                          controller: textEditingController,
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'search_products'.tr,
                            border: InputBorder.none,
                          ),
                          style: Get.find<FontStyles>()
                              .poppinsRegular
                              .copyWith(fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) {
                            categoryController.searchData(
                              query,
                              categoryController.subCategoryIndex == 0
                                  ? widget.categoryID
                                  : categoryController
                                      .subCategoryList[
                                          categoryController.subCategoryIndex]
                                      .id
                                      .toString(),
                              categoryController.type,
                            );
                            textEditingController.clear();
                          })
                      : Text(widget.categoryName,
                          style: Get.find<FontStyles>().poppinsRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                              )),
                  centerTitle: true,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).textTheme.bodyText1.color,
                    onPressed: () {
                      if (categoryController.isSearching) {
                        categoryController.toggleSearch();
                      } else {
                        Get.back();
                      }
                    },
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () => categoryController.toggleSearch(),
                      icon: Icon(
                        categoryController.isSearching
                            ? Icons.close_sharp
                            : Icons.search,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                    ),
                  ],
                ),
          body: GetBuilder<CategoryViewModel>(
              init: Get.find<CategoryViewModel>(),
              builder: (categoryViewModel) {
                if (categoryController.isSearching) {
                  if (categoryController.searchProductList == null) {
                    return Container();
                  } else {
                    if (categoryController.searchProductList.isEmpty) {
                      return Center(
                          child: NoDataScreen(text: "no_food_available".tr));
                    } else {
                      return ListView.builder(
                          itemCount:
                              categoryController.searchProductList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ProductWidget(
                              product:
                                  categoryController.searchProductList[index],
                              isRestaurant: false,
                              restaurant: null,
                              index: index,
                              length:
                                  categoryController.searchProductList.length,
                              inRestaurant: true,
                              isCampaign: false,
                            );
                          });
                    }
                  }
                } else {
                  return Obx(() {
                    if (categoryViewModel.isLoading.isTrue) {
                      return Center(child: CustomLoader());
                    }
                    return SizedBox(
                      width: Dimensions.WEB_MAX_WIDTH,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                height: Dimensions.blockscreenVertical * 7,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        categoryViewModel.subCategories.length,
                                    itemBuilder: (context, index) =>
                                        GestureDetector(
                                          onTap: () => categoryViewModel
                                              .setSubCategoryIndex(
                                                  index,
                                                  categoryViewModel
                                                      .subCategories[index].id
                                                      .toString()),
                                          child: Container(
                                              height: 20,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: categoryViewModel.subCategoryIndex == index
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Theme.of(context)
                                                          .backgroundColor,
                                                  border: categoryViewModel
                                                              .subCategoryIndex ==
                                                          index
                                                      ? Border.all(
                                                          color: Theme.of(context)
                                                              .primaryColor)
                                                      : Border.all(
                                                          color: Theme.of(context)
                                                              .disabledColor)),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimensions.blockscreenVertical * 2,
                                                  horizontal: Dimensions.blockscreenHorizontal * 4),
                                              child: Text(
                                                categoryViewModel
                                                    .subCategories[index].name,
                                                style: Get.find<FontStyles>()
                                                    .poppinsRegular
                                                    .copyWith(
                                                        color: categoryViewModel
                                                                    .subCategoryIndex ==
                                                                index
                                                            ? Colors.white
                                                            : Theme.of(context)
                                                                .disabledColor),
                                                maxLines: 2,
                                              )),
                                        ))),
                            SizedBox(
                              height: Dimensions.blockscreenVertical * 2,
                            ),
                            categoryViewModel.categoryProducts.isNotEmpty
                                ? Expanded(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: categoryViewModel
                                            .categoryProducts.length,
                                        itemBuilder: (context, index) {
                                          return ProductWidget(
                                            product: categoryViewModel
                                                .categoryProducts[index],
                                            isRestaurant: false,
                                            restaurant: null,
                                            index: index,
                                            length: categoryViewModel
                                                .categoryProducts.length,
                                            inRestaurant: true,
                                            isCampaign: false,
                                          );
                                        }))
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.blockscreenVertical * 7),
                                    child: Center(
                                        child: NoDataScreen(
                                            text: "no_food_available".tr)),
                                  )
                          ]),
                    );
                  });
                }
              }),
        ),
      );
    });
  }
}

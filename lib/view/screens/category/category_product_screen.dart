import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/theme/font_styles.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/product_widget.dart';
import 'package:efood_multivendor/view/base/veg_filter_widget.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<CategoryController>().getSubCategoryList(widget.categoryID);
    scrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryProductList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
    restaurantScrollController?.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          Get.find<CategoryController>().categoryRestList != null &&
          !Get.find<CategoryController>().isLoading) {
        int pageSize =
            (Get.find<CategoryController>().restPageSize / 10).ceil();
        if (Get.find<CategoryController>().offset < pageSize) {
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryRestaurantList(
            Get.find<CategoryController>().subCategoryIndex == 0
                ? widget.categoryID
                : Get.find<CategoryController>()
                    .subCategoryList[
                        Get.find<CategoryController>().subCategoryIndex]
                    .id
                    .toString(),
            Get.find<CategoryController>().offset + 1,
            Get.find<CategoryController>().type,
            false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (categoryController) {
      List<Product> _products;
      List<Restaurant> _restaurants;
      if (categoryController.categoryProductList != null &&
          categoryController.searchProductList != null) {
        _products = [];
        if (categoryController.isSearching) {
          _products.addAll(categoryController.searchProductList);
        } else {
          _products.addAll(categoryController.categoryProductList);
        }
      }
      if (categoryController.categoryRestList != null &&
          categoryController.searchRestList != null) {
        _restaurants = [];
        if (categoryController.isSearching) {
          _restaurants.addAll(categoryController.searchRestList);
        } else {
          _restaurants.addAll(categoryController.categoryRestList);
        }
      }

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
                          autofocus: true,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          style: Get.find<FontStyles>()
                              .poppinsRegular
                              .copyWith(fontSize: Dimensions.fontSizeLarge),
                          onSubmitted: (String query) =>
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
                          ),
                        )
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
          body: SizedBox(
            width: Dimensions.WEB_MAX_WIDTH,
            child: Column(children: [
              Center(
                  child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                color: Theme.of(context).backgroundColor,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).disabledColor,
                  unselectedLabelStyle: Get.find<FontStyles>()
                      .poppinsRegular
                      .copyWith(
                          color: Theme.of(context).disabledColor,
                          fontSize: Dimensions.fontSizeSmall),
                  labelStyle: Get.find<FontStyles>().poppinsBold.copyWith(
                      fontSize: Dimensions.fontSizeSmall,
                      color: Theme.of(context).primaryColor),
                  tabs: [
                    Tab(text: 'food'.tr),
                    Tab(text: 'restaurants'.tr),
                  ],
                ),
              )),
              VegFilterWidget(
                  type: categoryController.type,
                  onSelected: (String type) {
                    if (categoryController.isSearching) {
                      categoryController.searchData(
                        categoryController.subCategoryIndex == 0
                            ? widget.categoryID
                            : categoryController
                                .subCategoryList[
                                    categoryController.subCategoryIndex]
                                .id
                                .toString(),
                        '1',
                        type,
                      );
                    } else {
                      if (categoryController.isRestaurant) {
                        categoryController.getCategoryRestaurantList(
                          categoryController.subCategoryIndex == 0
                              ? widget.categoryID
                              : categoryController
                                  .subCategoryList[
                                      categoryController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          type,
                          true,
                        );
                      } else {
                        categoryController.getCategoryProductList(
                          categoryController.subCategoryIndex == 0
                              ? widget.categoryID
                              : categoryController
                                  .subCategoryList[
                                      categoryController.subCategoryIndex]
                                  .id
                                  .toString(),
                          1,
                          type,
                          true,
                        );
                      }
                    }
                  }),
              Expanded(
                  child: NotificationListener(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    if ((_tabController.index == 1 &&
                            !categoryController.isRestaurant) ||
                        _tabController.index == 0 &&
                            categoryController.isRestaurant) {
                      categoryController
                          .setRestaurant(_tabController.index == 1);
                      if (categoryController.isSearching) {
                        categoryController.searchData(
                          categoryController.searchText,
                          categoryController.subCategoryIndex == 0
                              ? widget.categoryID
                              : categoryController
                                  .subCategoryList[
                                      categoryController.subCategoryIndex]
                                  .id
                                  .toString(),
                          categoryController.type,
                        );
                      } else {
                        if (_tabController.index == 1) {
                          categoryController.getCategoryRestaurantList(
                            categoryController.subCategoryIndex == 0
                                ? widget.categoryID
                                : categoryController
                                    .subCategoryList[
                                        categoryController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            categoryController.type,
                            false,
                          );
                        } else {
                          categoryController.getCategoryProductList(
                            categoryController.subCategoryIndex == 0
                                ? widget.categoryID
                                : categoryController
                                    .subCategoryList[
                                        categoryController.subCategoryIndex]
                                    .id
                                    .toString(),
                            1,
                            categoryController.type,
                            false,
                          );
                        }
                      }
                    }
                  }
                  return false;
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _products != null
                        ? _products.isNotEmpty
                            ? ListView.builder(
                                controller: scrollController,
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.blockscreenVertical * 2,
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                itemCount: _products.length,
                                itemBuilder: ((context, index) {
                                  return ProductWidget(
                                    product: _products[index],
                                    isRestaurant: false,
                                    restaurant: null,
                                    index: index,
                                    length: _products.length,
                                    inRestaurant: true,
                                    isCampaign: false,
                                  );
                                }))
                            : SingleChildScrollView(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.blockscreenVertical *
                                                12),
                                    child: NoDataScreen(
                                        text: "no_food_available".tr)),
                              )
                        : Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                    _restaurants != null
                        ? _restaurants.isNotEmpty
                            ? ListView.builder(
                                controller: restaurantScrollController,
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.blockscreenVertical * 2,
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                itemCount: _restaurants.length,
                                itemBuilder: ((context, index) {
                                  return ProductWidget(
                                    product: null,
                                    isRestaurant: true,
                                    restaurant: _restaurants[index],
                                    index: index,
                                    length: _restaurants.length,
                                    inRestaurant: true,
                                    isCampaign: false,
                                  );
                                }))
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          Dimensions.blockscreenVertical * 12),
                                  child: NoDataScreen(
                                      text: 'no_restaurant_available'.tr),
                                ),
                              )
                        : Center(
                            child: CircularProgressIndicator.adaptive(),
                          ),
                  ],
                ),
              )),
              categoryController.isLoading
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor)),
                    ))
                  : SizedBox(),
            ]),
          ),
        ),
      );
    });
  }
}

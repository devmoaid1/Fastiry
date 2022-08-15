import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/search_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/web_menu_bar.dart';
import 'package:efood_multivendor/view/screens/search/widget/filter_widget.dart';
import 'package:efood_multivendor/view/screens/search/widget/history_card.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_field.dart';
import 'package:efood_multivendor/view/screens/search/widget/search_result_widget.dart';
import 'package:efood_multivendor/view/screens/search/widget/suggestion_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../theme/font_styles.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if (_isLoggedIn) {
      Get.find<SearchController>().getSuggestedFoods();
    }
    Get.find<SearchController>().getHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<SearchController>().isSearchMode) {
          return true;
        } else {
          Get.find<SearchController>().setSearchMode(true);
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
        body: SafeArea(
            child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: GetBuilder<SearchController>(builder: (searchController) {
            _searchController.text = searchController.searchText;
            return Column(children: [
              Center(
                  child: SizedBox(
                      width: Dimensions.WEB_MAX_WIDTH,
                      child: Row(children: [
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Expanded(
                            child: SearchField(
                          controller: _searchController,
                          hint: 'search_food_or_restaurant'.tr,
                          suffixIcon: !searchController.isSearchMode
                              ? Icons.filter_list
                              : Icons.search,
                          iconPressed: () =>
                              _actionSearch(searchController, false),
                          onSubmit: (text) =>
                              _actionSearch(searchController, true),
                        )),
                        CustomButton(
                          onPressed: () => searchController.isSearchMode
                              ? Get.back()
                              : searchController.setSearchMode(true),
                          buttonText: 'cancel'.tr,
                          transparent: true,
                          width: Dimensions.blockscreenHorizontal * 20,
                        ),
                      ]))),
              Expanded(
                  child: searchController.isSearchMode
                      ? SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL,
                              vertical: Dimensions.blockscreenVertical * 2),
                          child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    searchController.historyList.length > 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                                Text('history'.tr,
                                                    style: Get.find<
                                                            FontStyles>()
                                                        .poppinsMedium
                                                        .copyWith(
                                                            fontSize: Dimensions
                                                                    .blockscreenHorizontal *
                                                                5.5)),
                                                InkWell(
                                                  onTap: () => searchController
                                                      .clearSearchAddress(),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: Dimensions
                                                            .PADDING_SIZE_SMALL,
                                                        horizontal: 4),
                                                    child: Text('clear_all'.tr,
                                                        style: Get.find<
                                                                FontStyles>()
                                                            .poppinsRegular
                                                            .copyWith(
                                                              fontSize: Dimensions
                                                                      .blockscreenHorizontal *
                                                                  4,
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                            )),
                                                  ),
                                                ),
                                              ])
                                        : SizedBox(),
                                    ListView.builder(
                                      itemCount:
                                          searchController.historyList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return HistoryCard(
                                            index: index,
                                            searchController: searchController);
                                      },
                                    ),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_LARGE),
                                    (_isLoggedIn &&
                                            searchController
                                                    .suggestedFoodList !=
                                                null)
                                        ? Text(
                                            'suggestions'.tr,
                                            style: Get.find<FontStyles>()
                                                .poppinsMedium
                                                .copyWith(
                                                    fontSize: Dimensions
                                                            .blockscreenHorizontal *
                                                        5.5),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),
                                    (_isLoggedIn &&
                                            searchController
                                                    .suggestedFoodList !=
                                                null)
                                        ? searchController
                                                    .suggestedFoodList.length >
                                                0
                                            ? GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      ResponsiveHelper.isMobile(
                                                              context)
                                                          ? 3
                                                          : 4,
                                                  childAspectRatio: Dimensions
                                                          .blockscreenHorizontal /
                                                      5.5,
                                                  mainAxisSpacing: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                  crossAxisSpacing: Dimensions
                                                      .PADDING_SIZE_SMALL,
                                                ),
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: searchController
                                                    .suggestedFoodList.length,
                                                itemBuilder: (context, index) {
                                                  return SuggestionCard(
                                                      index: index,
                                                      searchController:
                                                          searchController);
                                                },
                                              )
                                            : Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10),
                                                child: Text(
                                                    'no_suggestions_available'
                                                        .tr))
                                        : SizedBox(),
                                  ])),
                        )
                      : SearchResultWidget(
                          searchText: _searchController.text.trim())),
            ]);
          }),
        )),
      ),
    );
  }

  void _actionSearch(SearchController searchController, bool isSubmit) {
    if (searchController.isSearchMode || isSubmit) {
      if (_searchController.text.trim().isNotEmpty) {
        searchController.searchData(_searchController.text.trim());
      } else {
        showCustomSnackBar('search_food_or_restaurant'.tr);
      }
    } else {
      List<double> _prices = [];
      if (!searchController.isRestaurant) {
        searchController.allProductList
            .forEach((product) => _prices.add(product.price));
        _prices.sort();
      }
      double _maxValue =
          _prices.length > 0 ? _prices[_prices.length - 1] : 1000;
      Get.dialog(FilterWidget(
          maxValue: _maxValue, isRestaurant: searchController.isRestaurant));
    }
  }
}

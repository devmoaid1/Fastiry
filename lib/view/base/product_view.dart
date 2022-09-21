import '/data/model/response/product_model.dart';
import '/data/model/response/restaurant_model.dart';
import '/helper/responsive_helper.dart';
import '/util/dimensions.dart';
import '/view/base/no_data_screen.dart';
import '/view/base/product_shimmer.dart';
import '/view/base/product_widget.dart';
import '/view/base/veg_filter_widget.dart';
import '/view/screens/home/theme1/restaurant_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final List<Product> products;
  final List<Restaurant> restaurants;
  final bool isRestaurant;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool isCampaign;
  final bool inRestaurantPage;
  final String type;
  final Function(String type) onVegFilterTap;
  final bool showTheme1Restaurant;
  ProductView(
      {@required this.restaurants,
      @required this.products,
      @required this.isRestaurant,
      this.isScrollable = false,
      this.shimmerLength = 20,
      this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      this.noDataText,
      this.isCampaign = false,
      this.inRestaurantPage = false,
      this.type,
      this.onVegFilterTap,
      this.showTheme1Restaurant = false});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    if (isRestaurant) {
      _isNull = restaurants == null;
      if (!_isNull) {
        _length = restaurants.length;
      }
    } else {
      _isNull = products == null;
      if (!_isNull) {
        _length = products.length;
      }
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      type != null
          ? VegFilterWidget(type: type, onSelected: onVegFilterTap)
          : SizedBox(),
      !_isNull
          ? _length > 0
              ? GridView.builder(
                  key: UniqueKey(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 1,
                    childAspectRatio: ResponsiveHelper.isDesktop(context)
                        ? 4
                        : Dimensions.screenWidth < 411
                            ? Dimensions.blockscreenHorizontal * 0.4
                            : showTheme1Restaurant
                                ? 16 / 9
                                : 16 / 8, //60
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
                  ),
                  physics: isScrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _length,
                  padding: padding,
                  itemBuilder: (context, index) {
                    return showTheme1Restaurant
                        ? RestaurantWidget(
                            restaurant: restaurants[index],
                            index: index,
                            inStore: inRestaurantPage)
                        : ProductWidget(
                            isRestaurant: isRestaurant,
                            product: isRestaurant ? null : products[index],
                            restaurant:
                                isRestaurant ? restaurants[index] : null,
                            index: index,
                            length: _length,
                            isCampaign: isCampaign,
                            inRestaurant: inRestaurantPage,
                          );
                  },
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.blockscreenVertical * 12),
                  child: NoDataScreen(
                    text: noDataText != null
                        ? noDataText
                        : isRestaurant
                            ? 'no_restaurant_available'.tr
                            : 'no_food_available'.tr,
                  ),
                )
          : GridView.builder(
              key: UniqueKey(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
                mainAxisSpacing: ResponsiveHelper.isDesktop(context)
                    ? Dimensions.PADDING_SIZE_LARGE
                    : 0.01,
                childAspectRatio: ResponsiveHelper.isDesktop(context)
                    ? 4
                    : showTheme1Restaurant
                        ? 1.9
                        : 4,
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
              ),
              physics: isScrollable
                  ? BouncingScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              shrinkWrap: isScrollable ? false : true,
              itemCount: shimmerLength,
              padding: padding,
              itemBuilder: (context, index) {
                return showTheme1Restaurant
                    ? RestaurantShimmer(isEnable: _isNull)
                    : ProductShimmer(
                        isEnabled: _isNull,
                        isRestaurant: isRestaurant,
                        hasDivider: index != shimmerLength - 1);
              },
            ),
    ]);
  }
}

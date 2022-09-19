import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/location_controller.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../theme/font_styles.dart';
import '../../../util/colors.dart';
import '../../../util/dimensions.dart';
import '../../base/paginated_list_view.dart';
import '../../base/product_view.dart';
import '../home/home_screen.dart';
import '../home/widget/filter_view.dart';

class FoodScreen extends StatefulWidget {
  FoodScreen({Key key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            toolbarHeight: Dimensions.blockscreenVertical * 12,
            expandedHeight: Dimensions.blockscreenVertical * 14,
            floating: true,
            elevation: 0,
            automaticallyImplyLeading: true,
            leading: InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).dividerColor,
                )),
            backgroundColor: Theme.of(context).backgroundColor,
            title: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "deliver_to".tr,
                    style: Get.find<FontStyles>().poppinsRegular.copyWith(
                        color: Theme.of(context).dividerColor,
                        fontSize: Dimensions.blockscreenHorizontal * 3.5),
                  ),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () => Get.toNamed(
                              RouteHelper.getAccessLocationRoute('home')),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: Dimensions.PADDING_SIZE_SMALL,
                              horizontal: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.PADDING_SIZE_SMALL
                                  : 0,
                            ),
                            child: GetBuilder<LocationController>(
                                builder: (locationController) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      locationController
                                          .getUserAddress()
                                          .address,
                                      style: Get.find<FontStyles>()
                                          .poppinsRegular
                                          .copyWith(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: Dimensions.fontSizeSmall,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ],
                              );
                            }),
                          ),
                        )),
                      ]),
                ],
              ),
            ),
          ),

          // search button

          SliverPersistentHeader(
            pinned: true,
            delegate: SliverDelegate(
                child: Container(
              height: Dimensions.blockscreenHorizontal * 20,
              width: Dimensions.WEB_MAX_WIDTH,
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_SMALL),
              child: InkWell(
                onTap: () => Get.toNamed(RouteHelper.getSearchRoute()),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).disabledColor),
                    boxShadow: Get.isDarkMode
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[300],
                                spreadRadius: 0.4,
                                blurRadius: 5)
                          ],
                  ),
                  child: Row(children: [
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Icon(
                      Icons.search,
                      size: 25,
                      color: extraLightGrey,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    Expanded(
                        child: Text(
                      'search_food_or_restaurant'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.find<FontStyles>().poppinsRegular.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 3.5,
                            color: extraLightGrey,
                          ),
                    )),
                  ]),
                ),
              ),
            )),
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  height: Dimensions.blockscreenVertical * 3,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.blockscreenVertical * 3,
                      horizontal: Dimensions.blockscreenHorizontal * 3),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      'all_restaurants'.tr,
                      style: Get.find<FontStyles>().poppinsMedium.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 4,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).dividerColor),
                    )),
                    FilterView(),
                  ]),
                ),
                GetBuilder<RestaurantController>(
                    builder: (restaurantController) {
                  return PaginatedListView(
                    scrollController: ScrollController(),
                    totalSize: restaurantController.restaurantModel != null
                        ? restaurantController.restaurantModel.totalSize
                        : null,
                    offset: restaurantController.restaurantModel != null
                        ? restaurantController.restaurantModel.offset
                        : null,
                    onPaginate: (int offset) async => await restaurantController
                        .getRestaurantList(offset, false),
                    productView: ProductView(
                      isRestaurant: true,
                      products: null,
                      showTheme1Restaurant: true,
                      restaurants: restaurantController.restaurantModel != null
                          ? restaurantController.restaurantModel.restaurants
                          : null,
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                            : Dimensions.PADDING_SIZE_SMALL,
                        vertical: ResponsiveHelper.isDesktop(context)
                            ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                            : 0,
                      ),
                    ),
                  );
                }),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

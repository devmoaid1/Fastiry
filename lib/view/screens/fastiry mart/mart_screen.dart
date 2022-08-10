import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/restaurant_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/colors.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/paginated_list_view.dart';
import '../../base/product_view.dart';
import '../home/home_screen.dart';
import '../home/widget/filter_view.dart';

class MartScreen extends StatefulWidget {
  MartScreen({Key key}) : super(key: key);

  @override
  State<MartScreen> createState() => _MartScreenState();
}

class _MartScreenState extends State<MartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            toolbarHeight: Dimensions.blockscreenVertical * 10,
            expandedHeight: Dimensions.blockscreenVertical * 12,
            floating: false,
            pinned: true,
            elevation: 1,
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: InkWell(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).dividerColor,
                )),
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              "fasteriy_mart".tr,
              style: poppinsRegular.copyWith(
                  color: Theme.of(context).dividerColor,
                  fontSize: Dimensions.blockscreenHorizontal * 4),
            ),
          ),

          // search button

          SliverPersistentHeader(
            pinned: false,
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
                    color: offWhite,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[Get.isDarkMode ? 800 : 300],
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
                      style: poppinsRegular.copyWith(
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.blockscreenVertical * 3,
                      horizontal: Dimensions.blockscreenHorizontal * 3),
                  child: Row(children: [
                    Expanded(
                        child: Text(
                      'all_restaurants'.tr,
                      style: poppinsRegular.copyWith(
                          fontSize: Dimensions.blockscreenHorizontal * 3.5,
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

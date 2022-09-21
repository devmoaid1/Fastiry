import '/controller/restaurant_controller.dart';
import '/util/app_constants.dart';
import '/util/dimensions.dart';
import '/view/base/custom_app_bar.dart';
import '/view/base/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/custom_loader.dart';

class AllRestaurantScreen extends StatefulWidget {
  final bool isPopular;
  AllRestaurantScreen({@required this.isPopular});

  @override
  State<AllRestaurantScreen> createState() => _AllRestaurantScreenState();
}

class _AllRestaurantScreenState extends State<AllRestaurantScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isPopular) {
        Get.find<RestaurantController>()
            .getPopularRestaurantList(false, 'all', false);
      } else {
        Get.find<RestaurantController>()
            .getLatestRestaurantList(false, 'all', false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
          title: widget.isPopular
              ? 'popular_restaurants'.tr
              : '${'new_on'.tr} ${AppConstants.APP_NAME}'),
      body: RefreshIndicator(
        onRefresh: () async {
          if (widget.isPopular) {
            await Get.find<RestaurantController>().getPopularRestaurantList(
              true,
              Get.find<RestaurantController>().type,
              false,
            );
          } else {
            await Get.find<RestaurantController>().getLatestRestaurantList(
              true,
              Get.find<RestaurantController>().type,
              false,
            );
          }
        },
        child: Scrollbar(
            child: SizedBox(
          width: Dimensions.WEB_MAX_WIDTH,
          child: GetBuilder<RestaurantController>(builder: (restController) {
            if (!restController.isLoading) {
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shrinkWrap: true,
                  itemCount: widget.isPopular
                      ? restController.popularRestaurantList.length
                      : restController.latestRestaurantList.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                        product: null,
                        isRestaurant: true,
                        inRestaurant: true,
                        restaurant: widget.isPopular
                            ? restController.popularRestaurantList[index]
                            : restController.latestRestaurantList[index],
                        index: index,
                        length: widget.isPopular
                            ? restController.popularRestaurantList.length
                            : restController.latestRestaurantList.length);
                  });
            }
            return Center(
              child: CustomLoader(),
            );
            // return ProductView(
            //   isRestaurant: true,
            //   products: null,
            //   noDataText: 'no_restaurant_available'.tr,
            //   restaurants: widget.isPopular
            //   ? restController.popularRestaurantList
            //   : restController.latestRestaurantList,
            //   type: restController.type,
            //   onVegFilterTap: (String type) {
            // if (widget.isPopular) {
            //   Get.find<RestaurantController>()
            //   .getPopularRestaurantList(true, type, true);
            // } else {
            //   Get.find<RestaurantController>()
            //   .getLatestRestaurantList(true, type, true);
            // }
            //   },
            // );
          }),
        )),
      ),
    );
  }
}

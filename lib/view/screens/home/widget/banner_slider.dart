import 'package:carousel_slider/carousel_slider.dart';
import '/controller/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/basic_campaign_model.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../data/model/response/restaurant_model.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_image.dart';
import '../../../base/product_bottom_sheet.dart';
import '../../restaurant/restaurant_screen.dart';

class BannerSlider extends StatelessWidget {
  final BannerController bannerController;
  final List<String> banners;
  final List<dynamic> bannersData;

  const BannerSlider(
      {Key key, this.bannerController, this.banners, this.bannersData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
        child: CarouselSlider.builder(
          carouselController: CarouselController(),
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: false,
            viewportFraction: 1,
            autoPlayInterval: Duration(seconds: 4),
            onPageChanged: (index, reason) {
              bannerController.setCurrentIndex(index, true);
            },
          ),
          itemCount: banners.length == 0 ? 1 : banners.length,
          itemBuilder: (context, index, _) {
            String _baseUrl = bannersData[index] is BasicCampaignModel
                ? Get.find<SplashController>()
                    .configModel
                    .baseUrls
                    .campaignImageUrl
                : Get.find<SplashController>()
                    .configModel
                    .baseUrls
                    .bannerImageUrl;
            return InkWell(
              onTap: () {
                onBannerTap(context, index);
              },
              child: Container(
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 300],
                        spreadRadius: 0.3,
                        blurRadius: 5)
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                  child:
                      GetBuilder<SplashController>(builder: (splashController) {
                    return CustomImage(
                      image:
                          '$_baseUrl/${bannerController.bannerImageList[index]}',
                      placeholder: Images.breakFastImage,
                      fit: BoxFit.fill,
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void onBannerTap(BuildContext context, int index) {
    if (bannersData[index] is Product) {
      Product _product = bannersData[index];
      ResponsiveHelper.isMobile(context)
          ? showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (con) => ProductBottomSheet(product: _product),
            )
          : showDialog(
              context: context,
              builder: (con) =>
                  Dialog(child: ProductBottomSheet(product: _product)),
            );
    } else if (bannersData[index] is Restaurant) {
      Restaurant _restaurant = bannersData[index];
      Get.toNamed(
        RouteHelper.getRestaurantRoute(_restaurant.id),
        arguments: RestaurantScreen(restaurant: _restaurant),
      );
    } else if (bannersData[index] is BasicCampaignModel) {
      BasicCampaignModel _campaign = bannersData[index];
      Get.toNamed(RouteHelper.getBasicCampaignRoute(_campaign));
    }
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:efood_multivendor/controller/banner_controller.dart';
import 'package:efood_multivendor/controller/splash_controller.dart';
import 'package:efood_multivendor/controller/theme_controller.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/product_bottom_sheet.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../../util/images.dart';
import '../../../base/custom_image.dart';

class BannerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return (bannerController.bannerImageList != null &&
              bannerController.bannerImageList.length == 0)
          ? SizedBox()
          : Container(
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.height * 0.6,
              padding:
                  EdgeInsets.only(top: Dimensions.blockscreenHorizontal * 10),
              child: bannerController.bannerImageList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 0.8,
                            onPageChanged: (index, reason) {
                              bannerController.setCurrentIndex(index, true);
                            },
                          ),
                          itemCount:
                              bannerController.bannerImageList.length == 0
                                  ? 1
                                  : bannerController.bannerImageList.length,
                          itemBuilder: (context, index, _) {
                            String _baseUrl = bannerController
                                    .bannerDataList[index] is BasicCampaignModel
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
                                if (bannerController.bannerDataList[index]
                                    is Product) {
                                  Product _product =
                                      bannerController.bannerDataList[index];
                                  ResponsiveHelper.isMobile(context)
                                      ? showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (con) => ProductBottomSheet(
                                              product: _product),
                                        )
                                      : showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                              child: ProductBottomSheet(
                                                  product: _product)),
                                        );
                                } else if (bannerController
                                    .bannerDataList[index] is Restaurant) {
                                  Restaurant _restaurant =
                                      bannerController.bannerDataList[index];
                                  Get.toNamed(
                                    RouteHelper.getRestaurantRoute(
                                        _restaurant.id),
                                    arguments: RestaurantScreen(
                                        restaurant: _restaurant),
                                  );
                                } else if (bannerController
                                        .bannerDataList[index]
                                    is BasicCampaignModel) {
                                  BasicCampaignModel _campaign =
                                      bannerController.bannerDataList[index];
                                  Get.toNamed(RouteHelper.getBasicCampaignRoute(
                                      _campaign));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 800 : 200],
                                        spreadRadius: 2,
                                        blurRadius: 5)
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  child: GetBuilder<SplashController>(
                                    builder: (splashController) {
                                      return CustomImage(
                                        image:
                                            '$_baseUrl/${bannerController.bannerImageList[index]}',
                                        placeholder: Images.breakFastImage,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerController.bannerImageList.map((bnr) {
                            int index =
                                bannerController.bannerImageList.indexOf(bnr);
                            return TabPageSelectorIndicator(
                              backgroundColor:
                                  index == bannerController.currentIndex
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                              borderColor: Theme.of(context).backgroundColor,
                              size: index == bannerController.currentIndex
                                  ? 10
                                  : 7,
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : Shimmer(
                      duration: Duration(seconds: 2),
                      enabled: bannerController.bannerImageList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                          )),
                    ),
            );
    });
  }
}

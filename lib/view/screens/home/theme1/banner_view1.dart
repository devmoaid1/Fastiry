import '/controller/banner_controller.dart';
import '/controller/home_controller.dart';
import '/util/dimensions.dart';
import '/view/screens/home/widget/banner_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      List<String> bannerList = bannerController.bannerImageList;
      List<dynamic> bannerDataList = bannerController.bannerDataList;

      return (bannerList != null && bannerList.length == 0)
          ? SizedBox()
          : Container(
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.height * 0.20,
              padding: EdgeInsets.symmetric(
                // vertical: Dimensions.blockscreenVertical,
                horizontal: Dimensions.blockscreenHorizontal * 4,
              ),
              child: bannerList != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BannerSlider(
                          bannerController: bannerController,
                          banners: bannerList,
                          bannersData: bannerDataList,
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerList.map((bnr) {
                            int index = bannerList.indexOf(bnr);
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
                      enabled: Get.find<HomeController>().isLoading &&
                          bannerList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Colors.grey[300],
                          )),
                    ),
            );
    });
  }
}

import '/controller/campaign_controller.dart';
import '/controller/splash_controller.dart';
import '/helper/responsive_helper.dart';
import '/helper/route_helper.dart';
import '/util/dimensions.dart';
import '/util/image_checker.dart';
import '/view/base/product_bottom_sheet.dart';
import '/view/base/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';

class ItemCampaignView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CampaignController>(builder: (campaignController) {
      return (campaignController.itemCampaignList != null &&
              campaignController.itemCampaignList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: TitleWidget(
                      title: 'campaigns'.tr,
                      onTap: () =>
                          Get.toNamed(RouteHelper.getItemCampaignRoute())),
                ),
                SizedBox(
                  height: 150,
                  child: campaignController.itemCampaignList != null
                      ? ListView.builder(
                          controller: ScrollController(),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.only(
                              left: Dimensions.PADDING_SIZE_SMALL),
                          itemCount:
                              campaignController.itemCampaignList.length > 10
                                  ? 10
                                  : campaignController.itemCampaignList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  right: Dimensions.PADDING_SIZE_SMALL,
                                  bottom: 5),
                              child: InkWell(
                                onTap: () {
                                  ResponsiveHelper.isMobile(context)
                                      ? Get.bottomSheet(
                                          ProductBottomSheet(
                                              product: campaignController
                                                  .itemCampaignList[index],
                                              isCampaign: true),
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                        )
                                      : Get.dialog(
                                          Dialog(
                                              child: ProductBottomSheet(
                                                  product: campaignController
                                                      .itemCampaignList[index],
                                                  isCampaign: true)),
                                        );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  child: checkImage(
                                      '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}'
                                      '/${campaignController.itemCampaignList[index].image}',
                                      150,
                                      150,
                                      BoxFit.fill),
                                  // child: CustomImage(
                                  //   image:
                                  //       '${Get.find<SplashController>().configModel.baseUrls.campaignImageUrl}'
                                  //       '/${campaignController.itemCampaignList[index].image}',
                                  //   height: 150,
                                  //   width: 150,
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                            );
                          },
                        )
                      : ItemCampaignShimmer(
                          campaignController: campaignController),
                ),
              ],
            );
    });
  }
}

class ItemCampaignShimmer extends StatelessWidget {
  final CampaignController campaignController;
  ItemCampaignShimmer({@required this.campaignController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          child: Shimmer(
            duration: Duration(seconds: 2),
            enabled: Get.find<HomeController>().isLoading,
            child: Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                color: Colors.grey[300],
              ),
            ),
          ),
        );
      },
    );
  }
}

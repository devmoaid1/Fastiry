import 'package:efood_multivendor/controller/category_controller.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/title_widget.dart';
import 'package:efood_multivendor/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../controller/home_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../base/custom_image.dart';

class CategoryView1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
              categoryController.categoryList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.blockscreenVertical * 3,
                      horizontal: Dimensions.blockscreenHorizontal * 4),
                  child: TitleWidget(
                      title: 'categories'.tr,
                      onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: Dimensions.blockscreenVertical * 22,
                        child: categoryController.categoryList != null
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    categoryController.categoryList.length > 15
                                        ? 15
                                        : categoryController
                                            .categoryList.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 4),
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () => Get.toNamed(
                                        RouteHelper.getCategoryProductRoute(
                                      categoryController.categoryList[index].id,
                                      categoryController
                                          .categoryList[index].name,
                                    )),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          right:
                                              Dimensions.blockscreenHorizontal *
                                                  5),
                                      height:
                                          Dimensions.blockscreenVertical * 15,
                                      width:
                                          Dimensions.blockscreenHorizontal * 35,
                                      child: Column(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              !Get.isDarkMode
                                                  ? BoxShadow(
                                                      color: Colors.grey[200],
                                                      spreadRadius: 0.4,
                                                      blurRadius: 7)
                                                  : BoxShadow(
                                                      color: Theme.of(context)
                                                          .backgroundColor)
                                            ],
                                          ),
                                          child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            // child: Image.asset(
                                            //   Images.breakFastImage,
                                            //   height: Dimensions
                                            //           .blockscreenVertical *
                                            //       15,
                                            //   width: Dimensions
                                            //           .blockscreenHorizontal *
                                            //       35,
                                            // ),
                                            child: CustomImage(
                                              height: Dimensions
                                                      .blockscreenVertical *
                                                  15,
                                              width: Dimensions
                                                      .blockscreenHorizontal *
                                                  35,
                                              placeholder:
                                                  Images.breakFastImage,
                                              image:
                                                  '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                                              // '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical:
                                                Dimensions.blockscreenVertical *
                                                    1.5,
                                          ),
                                          child: Text(
                                            categoryController
                                                .categoryList[index].name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: poppinsRegular.copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    3.5,
                                                color: Theme.of(context)
                                                    .dividerColor),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  );
                                },
                              )
                            : CategoryShimmer(
                                categoryController: categoryController),
                      ),
                    ),
                    ResponsiveHelper.isMobile(context)
                        ? SizedBox()
                        : categoryController.categoryList != null
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                              child: Container(
                                                  height: 550,
                                                  width: 600,
                                                  child: CategoryPopUp(
                                                    categoryController:
                                                        categoryController,
                                                  ))));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: Dimensions.PADDING_SIZE_SMALL),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text('view_all'.tr,
                                            style: TextStyle(
                                                fontSize: Dimensions
                                                    .PADDING_SIZE_DEFAULT,
                                                color: Theme.of(context)
                                                    .cardColor)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            : CategoryAllShimmer(
                                categoryController: categoryController)
                  ],
                ),
              ],
            );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.blockscreenVertical * 22,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1),
            child: SizedBox(
              child: Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL,
                  right: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                ),
                child: Shimmer(
                  duration: Duration(seconds: 2),
                  enabled: Get.find<HomeController>().isLoading,
                  child: Container(
                    height: Dimensions.blockscreenVertical * 22,
                    width: Dimensions.blockscreenHorizontal * 35,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryAllShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: Get.find<HomeController>().isLoading,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}

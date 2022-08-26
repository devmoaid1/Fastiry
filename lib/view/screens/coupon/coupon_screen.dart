import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/images.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';
import '../../../theme/font_styles.dart';

class CouponScreen extends StatefulWidget {
  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    super.initState();

    if (_isLoggedIn) {
      Get.find<CouponController>().getCouponList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(title: 'coupon'.tr),
      body: _isLoggedIn
          ? GetBuilder<CouponController>(builder: (couponController) {
              return couponController.couponList != null
                  ? couponController.couponList.length > 0
                      ? RefreshIndicator(
                          onRefresh: () async {
                            await couponController.getCouponList();
                          },
                          child: Scrollbar(
                              child: SizedBox(
                                  width: Dimensions.WEB_MAX_WIDTH,
                                  child: ListView.builder(
                                    itemCount:
                                        couponController.couponList.length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_LARGE),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: couponController
                                                  .couponList[index].code));
                                          showCustomSnackBar(
                                              'coupon_code_copied'.tr,
                                              isError: false);
                                        },
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SvgPicture.asset(
                                                        Images.discountIcon,
                                                        height: Dimensions
                                                                .blockscreenHorizontal *
                                                            10,
                                                        // width: Dimensions
                                                        //         .blockscreenHorizontal *
                                                        //     10,
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .color),
                                                    SizedBox(width: 40),
                                                    Expanded(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              ' ${couponController.couponList[index].discount}${couponController.couponList[index].discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} ${'off'.tr} ${couponController.couponList[index].title.tr}',
                                                              style: Get.find<
                                                                      FontStyles>()
                                                                  .poppinsMedium
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions.blockscreenHorizontal *
                                                                              4),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            SizedBox(
                                                                height: Dimensions
                                                                    .PADDING_SIZE_EXTRA_SMALL),
                                                            // Text(
                                                            //   '${couponController.couponList[index].discount}${couponController.couponList[index].discountType == 'percent' ? '%' : Get.find<SplashController>().configModel.currencySymbol} off',
                                                            //   style: Get.find<
                                                            //           FontStyles>()
                                                            //       .poppinsMedium
                                                            //       .copyWith(
                                                            //           color: Theme.of(
                                                            //                   context)
                                                            //               .dividerColor),
                                                            // ),

                                                            Row(children: [
                                                              Text(
                                                                '${'valid_until'.tr}:',
                                                                style: Get.find<
                                                                        FontStyles>()
                                                                    .poppinsRegular
                                                                    .copyWith(
                                                                        color: Theme.of(context)
                                                                            .disabledColor,
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              SizedBox(
                                                                  width: Dimensions
                                                                      .PADDING_SIZE_EXTRA_SMALL),
                                                              Text(
                                                                couponController
                                                                    .couponList[
                                                                        index]
                                                                    .expireDate,
                                                                style: Get.find<
                                                                        FontStyles>()
                                                                    .poppinsMedium
                                                                    .copyWith(
                                                                        color: Theme.of(context)
                                                                            .disabledColor,
                                                                        fontSize:
                                                                            Dimensions.fontSizeSmall),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ]),
                                                            // Row(children: [
                                                            //   Text(
                                                            //     '${'min_purchase'.tr}:',
                                                            //     style: Get.find<
                                                            //             FontStyles>()
                                                            //         .poppinsRegular
                                                            //         .copyWith(
                                                            //             color: Theme.of(
                                                            //                     context)
                                                            //                 .dividerColor,
                                                            //             fontSize: Dimensions
                                                            //                 .fontSizeSmall),
                                                            //     maxLines: 1,
                                                            //     overflow: TextOverflow
                                                            //         .ellipsis,
                                                            //   ),
                                                            //   SizedBox(
                                                            //       width: Dimensions
                                                            //           .PADDING_SIZE_EXTRA_SMALL),
                                                            //   Text(
                                                            //     PriceConverter
                                                            //         .convertPrice(
                                                            //             couponController
                                                            //                 .couponList[
                                                            //                     index]
                                                            //                 .minPurchase),
                                                            //     style: Get.find<
                                                            //             FontStyles>()
                                                            //         .poppinsMedium
                                                            //         .copyWith(
                                                            //             color: Theme.of(
                                                            //                     context)
                                                            //                 .dividerColor,
                                                            //             fontSize: Dimensions
                                                            //                 .fontSizeSmall),
                                                            //     maxLines: 1,
                                                            //     overflow: TextOverflow
                                                            //         .ellipsis,
                                                            //   ),
                                                            // ]),

                                                            Text(
                                                              '${couponController.couponList[index].data}',
                                                              style: Get.find<
                                                                      FontStyles>()
                                                                  .poppinsMedium
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions.blockscreenHorizontal *
                                                                              4),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ]),
                                                    ),
                                                  ]),
                                            ),
                                            Divider(
                                              color: Get.isDarkMode
                                                  ? Theme.of(context)
                                                      .disabledColor
                                                      .withOpacity(0.6)
                                                  : Colors.grey[300],
                                              thickness: 2,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ))),
                        )
                      : NoDataScreen(text: 'no_coupon_found'.tr)
                  : Center(child: CircularProgressIndicator());
            })
          : NotLoggedInScreen(),
    );
  }
}

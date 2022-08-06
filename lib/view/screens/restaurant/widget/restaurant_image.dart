import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/restaurant_model.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_image.dart';

class RestaurantImage extends StatelessWidget {
  final RestaurantController restaurantController;
  final Restaurant restaurant;
  const RestaurantImage(
      {Key key, @required this.restaurantController, @required this.restaurant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CustomImage(
        fit: BoxFit.fill,
        width: double.infinity,
        placeholder: Images.restaurant_cover,
        height: Dimensions.blockscreenVertical * 25,
        image:
            '${Get.find<SplashController>().configModel.baseUrls.restaurantCoverPhotoUrl}/${restaurant.coverPhoto}',
      ),
      !restaurantController.isAvailable
          ? Positioned(
              top: 0,
              left: 0,
              bottom: 22,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Colors.black.withOpacity(0.6)),
                child: Text(
                  'closed_now'.tr,
                  textAlign: TextAlign.center,
                  style:
                      robotoRegular.copyWith(color: Colors.white, fontSize: 12),
                ),
              ))
          : SizedBox(),
      Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          child: Stack(children: [
            CustomImage(
              image:
                  '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${restaurant.logo}',
              height: ResponsiveHelper.isDesktop(context)
                  ? 80
                  : Dimensions.blockscreenHorizontal * 15,
              width: ResponsiveHelper.isDesktop(context)
                  ? 100
                  : Dimensions.blockscreenHorizontal * 17,
              fit: BoxFit.fill,
            ),
          ]),
        ),
      ),
    ]);
  }
}

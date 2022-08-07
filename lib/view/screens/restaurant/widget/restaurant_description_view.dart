import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/rating_bar.dart';
import 'package:efood_multivendor/view/screens/restaurant/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../util/images.dart';

class RestaurantDescriptionView extends StatelessWidget {
  final Restaurant restaurant;
  RestaurantDescriptionView({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    Color _textColor =
        ResponsiveHelper.isDesktop(context) ? Colors.white : null;
    return Column(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        // restaurant name
        Text(
          restaurant.name,
          style: poppinsMedium.copyWith(
              fontSize: Dimensions.blockscreenHorizontal * 6,
              color: Theme.of(context).dividerColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: Dimensions.blockscreenHorizontal),

        // address
        Text(
          restaurant.address ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: poppinsRegular.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).disabledColor),
        ),

        // rating row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar(
                rating: restaurant.avgRating,
                ratingCount: restaurant.ratingCount),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () => Get.toNamed(
                  RouteHelper.getRestaurantReviewRoute(
                      restaurant.id, restaurant.name),
                  arguments: ReviewScreen(
                    restaurantID: restaurant.id.toString(),
                    restaurantName: restaurant.name,
                  )),
              child: Text(
                "review_rate".tr,
                style: poppinsRegular.copyWith(
                    color: Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
        SizedBox(
            height: ResponsiveHelper.isDesktop(context)
                ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                : 6),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('minimum_order'.tr,
              style: poppinsRegular.copyWith(
                fontSize: Dimensions.blockscreenHorizontal * 3,
                color: Theme.of(context).dividerColor,
              )),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(
            PriceConverter.convertPrice(restaurant.minimumOrder),
            style: poppinsMedium.copyWith(
                fontSize: Dimensions.blockscreenHorizontal * 3,
                color: Theme.of(context).primaryColor),
          ),
        ]),
      ]),
      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
      SizedBox(
          height: ResponsiveHelper.isDesktop(context)
              ? 30
              : Dimensions.PADDING_SIZE_SMALL),
      Row(children: [
        Expanded(child: SizedBox()),
        InkWell(
          onTap: () => Get.toNamed(RouteHelper.getMapRoute(
            AddressModel(
              id: restaurant.id,
              address: restaurant.address,
              latitude: restaurant.latitude,
              longitude: restaurant.longitude,
              contactPersonNumber: '',
              contactPersonName: '',
              addressType: '',
            ),
            'restaurant',
          )),
          child: Row(children: [
            SvgPicture.asset(
              Images.locationIconSvg,
              color: Theme.of(context).dividerColor,
              width: 25,
              height: 25,
            ),
            SizedBox(
              width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
            ),
            Text('view_on_map'.tr,
                style: poppinsRegular.copyWith(
                    fontSize: Dimensions.blockscreenHorizontal * 3,
                    color: Theme.of(context).dividerColor)),
          ]),
        ),
        Expanded(child: SizedBox()),
        Row(children: [
          SvgPicture.asset(
            Images.clockIcon,
            color: Theme.of(context).dividerColor,
            width: 25,
            height: 25,
          ),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Text(
            '${restaurant.deliveryTime} ${'min'.tr}',
            style: poppinsRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Theme.of(context).dividerColor),
          ),
        ]),
        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        (restaurant.delivery && restaurant.freeDelivery)
            ? Expanded(child: SizedBox())
            : SizedBox(),
        (restaurant.delivery && restaurant.freeDelivery)
            ? Row(children: [
                SvgPicture.asset(
                  Images.scooterIconSvg,
                  color: Theme.of(context).dividerColor,
                  width: 25,
                  height: 25,
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text('free_delivery'.tr,
                    style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall,
                        color: Theme.of(context).dividerColor)),
              ])
            : SizedBox(),
        Expanded(child: SizedBox()),
      ]),
    ]);
  }
}

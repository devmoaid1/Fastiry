import '/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../base/custom_image.dart';
import '../../product_details/productDetails.dart';

class SuggestionCard extends StatelessWidget {
  final SearchController searchController;
  final int index;
  const SuggestionCard(
      {Key key, @required this.index, @required this.searchController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            RouteHelper.getProductDetailsRoute(
                searchController.suggestedFoodList[index].id),
            arguments: ProductDetailsScreen(
                product: searchController.suggestedFoodList[index]));
      },
      child: Container(
        margin: EdgeInsets.only(right: Dimensions.blockscreenHorizontal * 5),
        width: Dimensions.blockscreenHorizontal * 35,
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                !Get.isDarkMode
                    ? BoxShadow(
                        color: Colors.grey[200],
                        spreadRadius: 0.4,
                        offset: Offset(0, 4),
                        blurRadius: 7)
                    : BoxShadow(color: Theme.of(context).backgroundColor)
              ],
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              child: CustomImage(
                width: Dimensions.blockscreenHorizontal * 35,
                height: 100,
                placeholder: Images.breakFastImage,
                image:
                    '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}'
                    '/${searchController.suggestedFoodList[index].image}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.blockscreenVertical * 1.5,
            ),
            child: Text(
              searchController.suggestedFoodList[index].name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Get.find<FontStyles>().poppinsRegular.copyWith(
                    fontSize: Dimensions.blockscreenHorizontal * 3.5,
                  ),
            ),
          ),
        ]),
      ),
    );
  }
}

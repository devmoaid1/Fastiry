import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_image.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const CategoryCard({
    Key key,
    @required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
        category.id,
        category.name,
      )),
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
                        blurRadius: 7)
                    : BoxShadow(color: Theme.of(context).backgroundColor)
              ],
            ),
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              child: CustomImage(
                width: Dimensions.blockscreenHorizontal * 35,
                height: Dimensions.blockscreenHorizontal * 25,
                placeholder: Images.breakFastImage,
                image:
                    '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${category.image}',
                // '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions.blockscreenVertical * 1.5,
            ),
            child: Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: poppinsMedium.copyWith(
                fontSize: Dimensions.blockscreenHorizontal * 3.8,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

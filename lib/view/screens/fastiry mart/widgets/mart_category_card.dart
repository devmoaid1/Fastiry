import 'package:efood_multivendor/data/model/response/category_model.dart';
import 'package:efood_multivendor/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';

class MartCategoryCard extends StatelessWidget {
  final CategoryModel category;
  const MartCategoryCard({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getCategoryProductRoute(
        category.id,
        Get.locale.languageCode == "en"
            ? category.name
            : category.translations[0].value,
      )),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CustomImage(
                image:
                    '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${category.image}',

                fit: BoxFit.fill,
                height: Dimensions.blockscreenVertical * 10,
                //
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              Get.locale.languageCode == "en"
                  ? category.name
                  : category.translations[0].value,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Get.find<FontStyles>().poppinsRegular,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}

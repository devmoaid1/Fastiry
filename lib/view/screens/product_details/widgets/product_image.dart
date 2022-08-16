import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_image.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  const ProductImage({Key key, @required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        child: CustomImage(
          image:
              '${Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${product.image}',
          width: double.infinity,
          height: Dimensions.screeHeight * 0.28,
          fit: BoxFit.fill,
        ),
      ),
      Align(
        alignment: Get.locale.languageCode == "en"
            ? Alignment.topLeft
            : Alignment.topRight,
        child: InkWell(
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.only(
                  top: Dimensions.blockscreenHorizontal * 2,
                  left: Dimensions.blockscreenHorizontal * 3,
                  right: Get.locale.languageCode != "en"
                      ? Dimensions.blockscreenHorizontal * 3
                      : 0),
              child: Icon(Icons.arrow_back_ios,
                  color: Theme.of(context).disabledColor),
            )),
      ),
    ]);
  }
}

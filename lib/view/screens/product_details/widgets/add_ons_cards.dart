import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';

class AddOnsCards extends StatelessWidget {
  final ProductController productController;
  final Product product;
  const AddOnsCards(
      {Key key, @required this.product, @required this.productController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.blockscreenHorizontal * 2,
        ),
        child: Text('addons'.tr,
            style: Get.find<FontStyles>()
                .poppinsMedium
                .copyWith(fontSize: Dimensions.blockscreenHorizontal * 4)),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      GridView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.blockscreenHorizontal * 4,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
          childAspectRatio: 16 / 3,
        ),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: product.addOns.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (!productController.addOnActiveList[index]) {
                productController.addAddOn(true, index);
              } else if (productController.addOnQtyList[index] == 1) {
                productController.addAddOn(false, index);
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.blockscreenHorizontal * 3),
              margin: EdgeInsets.only(
                  bottom: productController.addOnActiveList[index] ? 5 : 8),
              decoration: BoxDecoration(
                color: productController.addOnActiveList[index]
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor,
                border: !productController.addOnActiveList[index]
                    ? Border.all(
                        color: Theme.of(context).disabledColor, width: 2)
                    : null,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                boxShadow: productController.addOnActiveList[index]
                    ? Get.isDarkMode
                        ? null
                        : [
                            BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]
                    : null,
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                productController.addOnActiveList[index]
                    ? Icon(Icons.check, color: Colors.white)
                    : SizedBox(
                        width: Dimensions.blockscreenHorizontal * 5,
                      ),
                SizedBox(
                  width: Dimensions.blockscreenHorizontal,
                ),
                Text(
                  product.addOns[index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Get.find<FontStyles>().poppinsMedium.copyWith(
                        color: productController.addOnActiveList[index]
                            ? Colors.white
                            : Theme.of(context).dividerColor,
                      ),
                ),
                Expanded(child: SizedBox()),
                Text(
                  product.addOns[index].price > 0
                      ? "(${PriceConverter.convertPrice(product.addOns[index].price)} +)"
                      : 'free'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Get.find<FontStyles>().poppinsRegular.copyWith(
                        color: productController.addOnActiveList[index]
                            ? Colors.white
                            : Theme.of(context).disabledColor,
                        fontSize: Dimensions.blockscreenHorizontal * 3.3,
                      ),
                ),
              ]),
            ),
          );
        },
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
    ]);
  }
}

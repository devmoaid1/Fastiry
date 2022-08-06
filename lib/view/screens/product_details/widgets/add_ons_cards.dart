import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class AddOnsCards extends StatelessWidget {
  final ProductController productController;
  final Product product;
  const AddOnsCards(
      {Key key, @required this.product, @required this.productController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('addons'.tr, style: poppinsMedium),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10,
          childAspectRatio: (1 / 1.1),
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
              margin: EdgeInsets.only(
                  bottom: productController.addOnActiveList[index] ? 2 : 20),
              decoration: BoxDecoration(
                color: productController.addOnActiveList[index]
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                border: productController.addOnActiveList[index]
                    ? null
                    : Border.all(
                        color: Theme.of(context).disabledColor, width: 2),
                boxShadow: productController.addOnActiveList[index]
                    ? [
                        BoxShadow(
                            color: Colors.grey[Get.isDarkMode ? 700 : 300],
                            blurRadius: 5,
                            spreadRadius: 1)
                      ]
                    : null,
              ),
              child: Column(children: [
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.addOns[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: poppinsMedium.copyWith(
                            color: productController.addOnActiveList[index]
                                ? Colors.white
                                : Colors.black,
                            fontSize: Dimensions.fontSizeSmall,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          product.addOns[index].price > 0
                              ? PriceConverter.convertPrice(
                                  product.addOns[index].price)
                              : 'free'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                            color: productController.addOnActiveList[index]
                                ? Colors.white
                                : Colors.black,
                            fontSize: Dimensions.fontSizeExtraSmall,
                          ),
                        ),
                      ]),
                ),
                productController.addOnActiveList[index]
                    ? Container(
                        height: 25,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).cardColor),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (productController.addOnQtyList[index] >
                                        1) {
                                      productController.setAddOnQuantity(
                                          false, index);
                                    } else {
                                      productController.addAddOn(false, index);
                                    }
                                  },
                                  child: Center(
                                      child: Icon(Icons.remove, size: 15)),
                                ),
                              ),
                              Text(
                                productController.addOnQtyList[index]
                                    .toString(),
                                style: poppinsMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => productController
                                      .setAddOnQuantity(true, index),
                                  child:
                                      Center(child: Icon(Icons.add, size: 15)),
                                ),
                              ),
                            ]),
                      )
                    : SizedBox(),
              ]),
            ),
          );
        },
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
    ]);
  }
}

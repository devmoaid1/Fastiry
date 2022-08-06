import 'package:efood_multivendor/controller/product_controller.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class VariationCards extends StatelessWidget {
  final ProductController productController;
  final Product product;
  const VariationCards(
      {Key key, @required this.productController, @required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: product.choiceOptions.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.blockscreenHorizontal * 2,
            ),
            child: Text('Select ${product.choiceOptions[index].title}',
                style: poppinsMedium.copyWith(
                    fontSize: Dimensions.blockscreenHorizontal * 4)),
          ),
          SizedBox(height: Dimensions.blockscreenVertical * 2),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.blockscreenHorizontal * 4,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10,
                childAspectRatio: 16 / 3,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: product.choiceOptions[index].options.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    print('-----and ${productController.cartIndex}///-----');
                    productController.setCartVariationIndex(index, i, product);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.blockscreenHorizontal * 3),
                    decoration: BoxDecoration(
                      color: productController.variationIndex[index] != i
                          ? Theme.of(context).backgroundColor
                          : Theme.of(context).primaryColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      border: productController.variationIndex[index] != i
                          ? Border.all(
                              color: Theme.of(context).disabledColor, width: 2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        productController.variationIndex[index] == i
                            ? Icon(Icons.check, color: Colors.white)
                            : SizedBox(
                                width: Dimensions.blockscreenHorizontal * 5,
                              ),
                        SizedBox(
                          width: Dimensions.blockscreenHorizontal,
                        ),
                        Text(
                          product.choiceOptions[index].options[i].trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                            color: productController.variationIndex[index] != i
                                ? Theme.of(context).dividerColor
                                : Colors.white,
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Text(
                          '(${PriceConverter.convertPrice(((product.variations[i].price) - (product.price)))}+)',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsRegular.copyWith(
                            color: productController.variationIndex[index] != i
                                ? Theme.of(context).dividerColor
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
              height: index != product.choiceOptions.length - 1
                  ? Dimensions.PADDING_SIZE_LARGE
                  : 0),
        ]);
      },
    );
  }
}
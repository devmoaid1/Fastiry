import '/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/wishlist_controller.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';
import '../../../../theme/font_styles.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_snackbar.dart';
import '../../../base/quantity_button.dart';
import '../../../base/rating_bar.dart';

class ProductDetailsCard extends StatelessWidget {
  final ProductController productController;
  final Product product;
  final double discount;
  final String discountType;
  const ProductDetailsCard(
      {Key key,
      @required this.productController,
      @required this.product,
      @required this.discount,
      @required this.discountType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Product

          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.blockscreenHorizontal * 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: Dimensions.screenWidth * 0.8,
                      child: Text(product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Get.find<FontStyles>().poppinsMedium.copyWith(
                              fontSize: Dimensions.blockscreenHorizontal * 5)),
                    ),
                    GetBuilder<WishListController>(builder: (wishController) {
                      bool _isWished =
                          wishController.wishProductIdList.contains(product.id);
                      return InkWell(
                        onTap: () {
                          if (Get.find<AuthController>().isLoggedIn()) {
                            _isWished
                                ? wishController.removeFromWishList(
                                    product.id, false)
                                : wishController.addToWishList(
                                    product, null, false);
                          } else {
                            showCustomSnackBar('you_are_not_logged_in'.tr);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                              Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          ),
                          child: Icon(
                            _isWished ? Icons.favorite : Icons.favorite_border,
                            size: 25,
                            color: _isWished
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).disabledColor,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                SizedBox(
                  height: Dimensions.blockscreenVertical * 0.5,
                ),
                Text(product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Get.find<FontStyles>().poppinsRegular.copyWith(
                        fontSize: Dimensions.blockscreenHorizontal * 4)),
                SizedBox(
                  height: Dimensions.blockscreenVertical,
                ),
                Row(
                  children: [
                    Text(
                      PriceConverter.convertPrice(product.price,
                          discount: discount, discountType: discountType),
                      style: Get.find<FontStyles>().poppinsRegular.copyWith(
                          color: Theme.of(context).dividerColor,
                          fontSize: Dimensions.blockscreenHorizontal * 4),
                    ),
                    SizedBox(
                        width: discount > 0
                            ? Dimensions.PADDING_SIZE_EXTRA_SMALL
                            : 0),
                    discount > 0
                        ? Text(
                            PriceConverter.convertPrice(product.price),
                            style: Get.find<FontStyles>()
                                .poppinsRegular
                                .copyWith(
                                  fontSize:
                                      Dimensions.blockscreenHorizontal * 3.2,
                                  color: Theme.of(context)
                                      .disabledColor
                                      .withOpacity(0.8),
                                  decoration: TextDecoration.lineThrough,
                                ),
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar(
                        rating: product.avgRating,
                        ratingCount: product.ratingCount),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          QuantityButton(
                            fromProductPage: true,
                            onTap: () {
                              if (productController.quantity > 1) {
                                productController.setQuantity(false);
                              }
                            },
                            isIncrement: false,
                            canDecrement: productController.quantity != 1,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            child: Text(productController.quantity.toString(),
                                style: Get.find<FontStyles>()
                                    .poppinsMedium
                                    .copyWith(
                                        fontSize:
                                            Dimensions.blockscreenHorizontal *
                                                5)),
                          ),
                          QuantityButton(
                            fromProductPage: true,
                            onTap: () => productController.setQuantity(true),
                            isIncrement: true,
                          ),
                        ]),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Divider(
                    height: 20,
                    thickness: 6,
                    color: Get.isDarkMode
                        ? Theme.of(context).disabledColor.withOpacity(0.3)
                        : Colors.grey[200],
                  ),
                )
              ],
            ),
          )
        ]);
  }
}

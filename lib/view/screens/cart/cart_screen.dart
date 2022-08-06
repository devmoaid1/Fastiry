import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/helper/date_converter.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/util/styles.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatefulWidget {
  final fromNav;
  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          onBackPressed: () {
            Get.find<CartController>().update();
            Get.back();
          },
          isBackButtonExist:
              (ResponsiveHelper.isDesktop(context) || !widget.fromNav),
          isWithLogo: true),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          List<List<AddOns>> _addOnsList = [];
          List<bool> _availableList = [];
          double _itemPrice = 0;
          double _addOns = 0;
          cartController.cartList.forEach((cartModel) {
            List<AddOns> _addOnList = [];
            cartModel.addOnIds.forEach((addOnId) {
              for (AddOns addOns in cartModel.product.addOns) {
                if (addOns.id == addOnId.id) {
                  _addOnList.add(addOns);
                  break;
                }
              }
            });
            _addOnsList.add(_addOnList);

            _availableList.add(DateConverter.isAvailable(
                cartModel.product.availableTimeStarts,
                cartModel.product.availableTimeEnds));

            for (int index = 0; index < _addOnList.length; index++) {
              _addOns = _addOns +
                  (_addOnList[index].price *
                      cartModel.addOnIds[index].quantity);
            }
            _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
          });
          double _subTotal = _itemPrice + _addOns;

          return cartController.cartList.length > 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.blockscreenHorizontal * 3,
                          horizontal: Dimensions.blockscreenHorizontal * 2),
                      child: Text("Shopping Cart",
                          textAlign: TextAlign.left,
                          style: poppinsMedium.copyWith(
                            fontSize: Dimensions.blockscreenHorizontal * 5,
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: BouncingScrollPhysics(),
                          child: SizedBox(
                            width: Dimensions.WEB_MAX_WIDTH,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cartController.cartList.length,
                                    itemBuilder: (context, index) {
                                      return CartProductWidget(
                                          cart: cartController.cartList[index],
                                          cartIndex: index,
                                          addOns: _addOnsList[index],
                                          isAvailable: _availableList[index]);
                                    },
                                  ),
                                  SizedBox(
                                      height:
                                          Dimensions.blockscreenVertical * 2),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.blockscreenHorizontal *
                                                3,
                                        horizontal:
                                            Dimensions.blockscreenHorizontal *
                                                2),
                                    child: Text("Summary",
                                        textAlign: TextAlign.left,
                                        style: poppinsMedium.copyWith(
                                          fontSize:
                                              Dimensions.blockscreenHorizontal *
                                                  5,
                                        )),
                                  ),
                                  // Total
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.blockscreenHorizontal *
                                                2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('item_price'.tr,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      4)),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  _itemPrice),
                                              style: poppinsRegular.copyWith(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                        ]),
                                  ),
                                  SizedBox(height: 10),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.blockscreenHorizontal *
                                                2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('addons'.tr,
                                              style: poppinsRegular.copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      4)),
                                          Text(
                                              '${PriceConverter.convertPrice(_addOns)}',
                                              style: poppinsRegular.copyWith(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                        ]),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.PADDING_SIZE_SMALL),
                                    child: Divider(
                                        thickness: 1,
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.5)),
                                  ),

                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.blockscreenHorizontal *
                                                2),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('subtotal'.tr,
                                              style: poppinsMedium.copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    5,
                                              )),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  _subTotal),
                                              style: poppinsMedium.copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    5,
                                              )),
                                        ]),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: CustomButton(
                          buttonText: 'proceed_to_checkout'.tr,
                          onPressed: () {
                            if (!cartController
                                    .cartList.first.product.scheduleOrder &&
                                _availableList.contains(false)) {
                              showCustomSnackBar(
                                  'one_or_more_product_unavailable'.tr);
                            } else {
                              Get.find<CouponController>()
                                  .removeCouponData(false);
                              Get.toNamed(RouteHelper.getCheckoutRoute('cart'));
                            }
                          }),
                    ),
                  ],
                )
              : NoDataScreen(isCart: true, text: '');
        },
      ),
    );
  }
}

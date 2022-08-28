import 'package:efood_multivendor/controller/cart_controller.dart';
import 'package:efood_multivendor/controller/coupon_controller.dart';
import 'package:efood_multivendor/helper/price_converter.dart';
import 'package:efood_multivendor/helper/responsive_helper.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/util/dimensions.dart';
import 'package:efood_multivendor/view/base/custom_app_bar.dart';
import 'package:efood_multivendor/view/base/custom_button.dart';
import 'package:efood_multivendor/view/base/custom_loader.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:efood_multivendor/view/base/no_data_screen.dart';
import 'package:efood_multivendor/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';
import '../../../theme/font_styles.dart';
import '../../../util/images.dart';
import '../../base/custom_image.dart';

class CartScreen extends StatefulWidget {
  final fromNav;
  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<CartController>().initCartScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          onBackPressed: () {
            Get.back();
            Get.find<CartController>().update();
          },
          isBackButtonExist:
              (ResponsiveHelper.isDesktop(context) || !widget.fromNav),
          isWithLogo: true),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          // List<List<AddOns>> _addOnsList = [];
          // List<bool> _availableList = [];
          // double _itemPrice = 0;
          // double _addOns = 0;
          // cartController.cartList.forEach((cartModel) {
          //   List<AddOns> _addOnList = [];
          //   cartModel.addOnIds.forEach((addOnId) {
          //     for (AddOns addOns in cartModel.product.addOns) {
          //       if (addOns.id == addOnId.id) {
          //         _addOnList.add(addOns);
          //         break;
          //       }
          //     }
          //   });
          //   _addOnsList.add(_addOnList);

          //   _availableList.add(DateConverter.isAvailable(
          //       cartModel.product.availableTimeStarts,
          //       cartModel.product.availableTimeEnds));

          //   for (int index = 0; index < _addOnList.length; index++) {
          //     _addOns = _addOns +
          //         (_addOnList[index].price *
          //             cartModel.addOnIds[index].quantity);
          //   }
          //   _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
          // });
          // double _subTotal = _itemPrice +
          //     _addOns +
          //     cartController.cartRestaurant.deliveryPrice;

          if (cartController.isLoading) {
            return Center(
              child: CustomLoader(),
            );
          }

          return cartController.cartList.length > 0
              ? SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Dimensions.blockscreenVertical,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.blockscreenHorizontal * 4),
                        child: cartController.cartRestaurant != null
                            ? Container(
                                height: Dimensions.screeHeight * 0.12,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              width: 1)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        child: Stack(children: [
                                          CustomImage(
                                            image:
                                                '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}/${cartController.cartRestaurant.logo}',
                                            height: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? 80
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    15,
                                            width: ResponsiveHelper.isDesktop(
                                                    context)
                                                ? 100
                                                : Dimensions
                                                        .blockscreenHorizontal *
                                                    17,
                                            fit: BoxFit.fill,
                                          ),
                                        ]),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          Dimensions.blockscreenHorizontal * 2,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(cartController.cartRestaurant.name,
                                            style: Get.find<FontStyles>()
                                                .poppinsMedium
                                                .copyWith(
                                                    fontSize: Dimensions
                                                            .blockscreenHorizontal *
                                                        4.5)),
                                        SizedBox(
                                          height:
                                              Dimensions.blockscreenVertical *
                                                  2.5,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              Images.scooterIconSvg,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .color,
                                              width: Get.locale
                                                          .languageCode !=
                                                      "en"
                                                  ? Dimensions
                                                          .blockscreenHorizontal *
                                                      4.5
                                                  : Dimensions
                                                          .blockscreenHorizontal *
                                                      4,
                                              height: Get.locale.languageCode !=
                                                      "en"
                                                  ? Dimensions
                                                          .blockscreenHorizontal *
                                                      4.5
                                                  : Dimensions
                                                          .blockscreenHorizontal *
                                                      4,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              cartController.cartRestaurant !=
                                                      null
                                                  ? PriceConverter.convertPrice(
                                                      cartController
                                                          .cartRestaurant
                                                          .deliveryPrice)
                                                  : PriceConverter.convertPrice(
                                                      0),
                                              style: Get.find<FontStyles>()
                                                  .poppinsRegular
                                                  .copyWith(
                                                      fontSize: Dimensions
                                                              .blockscreenHorizontal *
                                                          3),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                height: Dimensions.screeHeight * 0.12,
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.blockscreenHorizontal,
                            horizontal: Dimensions.blockscreenHorizontal * 2),
                        child: Text("shopping_cart".tr,
                            textAlign: TextAlign.left,
                            style:
                                Get.find<FontStyles>().poppinsMedium.copyWith(
                                      fontSize:
                                          Dimensions.blockscreenHorizontal * 5,
                                    )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
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
                                      addOns:
                                          cartController.addOnsList.isNotEmpty
                                              ? cartController.addOnsList[index]
                                              : [],
                                      isAvailable: cartController
                                              .availableList.isNotEmpty
                                          ? cartController.availableList[index]
                                          : false);
                                },
                              ),
                              SizedBox(
                                  height: Dimensions.blockscreenVertical * 2),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.blockscreenHorizontal * 3,
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                child: Text("summary".tr,
                                    textAlign: TextAlign.left,
                                    style: Get.find<FontStyles>()
                                        .poppinsMedium
                                        .copyWith(
                                          fontSize:
                                              Dimensions.blockscreenHorizontal *
                                                  5,
                                        )),
                              ),
                              // Total
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('item_price'.tr,
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      4)),
                                      Text(
                                          PriceConverter.convertPrice(
                                              cartController.itemPrice),
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                    ]),
                              ),
                              SizedBox(height: 10),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('addons'.tr,
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      4)),
                                      Text(
                                          '${PriceConverter.convertPrice(cartController.addOns)}',
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                    ]),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('delivery_price'.tr,
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                  fontSize: Dimensions
                                                          .blockscreenHorizontal *
                                                      4)),
                                      Text(
                                          cartController.cartRestaurant != null
                                              ? PriceConverter.convertPrice(
                                                  cartController.cartRestaurant
                                                      .deliveryPrice)
                                              : PriceConverter.convertPrice(0),
                                          style: Get.find<FontStyles>()
                                              .poppinsRegular
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              )),
                                    ]),
                              ),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_SMALL),
                                child: Divider(
                                    thickness: 1,
                                    color: Theme.of(context)
                                        .dividerColor
                                        .withOpacity(0.5)),
                              ),

                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.blockscreenHorizontal * 2),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('subtotal'.tr,
                                          style: Get.find<FontStyles>()
                                              .poppinsMedium
                                              .copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    5,
                                              )),
                                      Text(
                                          PriceConverter.convertPrice(
                                              cartController.subTotal),
                                          style: Get.find<FontStyles>()
                                              .poppinsMedium
                                              .copyWith(
                                                fontSize: Dimensions
                                                        .blockscreenHorizontal *
                                                    5,
                                              )),
                                    ]),
                              ),
                            ]),
                      ),
                      Container(
                        width: Dimensions.WEB_MAX_WIDTH,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        child: CustomButton(
                            buttonText: 'proceed_to_checkout'.tr,
                            onPressed: () {
                              if (!cartController
                                      .cartList.first.product.scheduleOrder &&
                                  cartController.availableList
                                      .contains(false)) {
                                showCustomSnackBar(
                                    'one_or_more_product_unavailable'.tr);
                              } else {
                                Get.find<CouponController>()
                                    .removeCouponData(false);
                                Get.toNamed(
                                    RouteHelper.getCheckoutRoute('cart'));
                              }
                            }),
                      ),
                    ],
                  ),
                )
              : NoDataScreen(isCart: true, text: '');
        },
      ),
    );
  }
}

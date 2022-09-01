import 'dart:convert';

import 'package:efood_multivendor/data/model/body/social_log_in_body.dart';
import 'package:efood_multivendor/data/model/response/address_model.dart';
import 'package:efood_multivendor/data/model/response/basic_campaign_model.dart';
import 'package:efood_multivendor/data/model/response/order_model.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/util/html_type.dart';
import 'package:efood_multivendor/view/base/image_viewer_screen.dart';
import 'package:efood_multivendor/view/base/internet_connection_wrapper.dart';
import 'package:efood_multivendor/view/base/not_found.dart';
import 'package:efood_multivendor/view/screens/address/add_address_screen.dart';
import 'package:efood_multivendor/view/screens/address/address_screen.dart';
import 'package:efood_multivendor/view/screens/auth/sign_in_screen.dart';
import 'package:efood_multivendor/view/screens/auth/sign_up_screen.dart';
import 'package:efood_multivendor/view/screens/cart/cart_screen.dart';
import 'package:efood_multivendor/view/screens/category/category_product_screen.dart';
import 'package:efood_multivendor/view/screens/category/category_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/checkout_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/order_successful_screen.dart';
import 'package:efood_multivendor/view/screens/checkout/payment_screen.dart';
import 'package:efood_multivendor/view/screens/coupon/coupon_screen.dart';
import 'package:efood_multivendor/view/screens/dashboard/dashboard_screen.dart';
import 'package:efood_multivendor/view/screens/fastiry%20mart/all_products.dart';
import 'package:efood_multivendor/view/screens/fastiry_food/food_screen.dart';
import 'package:efood_multivendor/view/screens/food/item_campaign_screen.dart';
import 'package:efood_multivendor/view/screens/food/popular_food_screen.dart';
import 'package:efood_multivendor/view/screens/forget/forget_pass_screen.dart';
import 'package:efood_multivendor/view/screens/forget/new_pass_screen.dart';
import 'package:efood_multivendor/view/screens/forget/social_phone_screen.dart';
import 'package:efood_multivendor/view/screens/forget/verification_screen.dart';
import 'package:efood_multivendor/view/screens/html/html_viewer_screen.dart';
import 'package:efood_multivendor/view/screens/interest/interest_screen.dart';
import 'package:efood_multivendor/view/screens/language/language_screen.dart';
import 'package:efood_multivendor/view/screens/location/access_location_screen.dart';
import 'package:efood_multivendor/view/screens/location/map_screen.dart';
import 'package:efood_multivendor/view/screens/location/pick_map_screen.dart';
import 'package:efood_multivendor/view/screens/notification/notification_screen.dart';
import 'package:efood_multivendor/view/screens/onboard/onboarding_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_details_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_screen.dart';
import 'package:efood_multivendor/view/screens/order/order_tracking_screen.dart';
import 'package:efood_multivendor/view/screens/profile/profile_screen.dart';
import 'package:efood_multivendor/view/screens/profile/update_profile_screen.dart';
import 'package:efood_multivendor/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/all_restaurant_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/campaign_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_product_search_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/restaurant_screen.dart';
import 'package:efood_multivendor/view/screens/restaurant/review_screen.dart';
import 'package:efood_multivendor/view/screens/search/search_screen.dart';
import 'package:efood_multivendor/view/screens/splash/splash_screen.dart';
import 'package:efood_multivendor/view/screens/support/support_screen.dart';
import 'package:efood_multivendor/view/screens/update/update_screen.dart';
import 'package:efood_multivendor/view/screens/wallet/wallet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../data/model/body/customer.dart';
import '../view/screens/fastiry mart/mart_screen.dart';
import '../view/screens/navigator_screen/navigator_screen.dart';
import '../view/screens/product_details/productDetails.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String navigatorScreen = '/navigator';
  static const String language = '/language';
  static const String allProducts = '/all-products';
  static const String onBoarding = '/on-boarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String fastiryFood = '/fastiry-food';
  static const String fastiryMart = '/fastiry-mart';
  static const String verification = '/verification';
  static const String accessLocation = '/access-location';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String search = '/search';
  static const String restaurant = '/restaurant';
  static const String productDetails = '/product-details';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String updateProfile = '/update-profile';
  static const String coupon = '/coupon';
  static const String notification = '/notification';
  static const String map = '/map';
  static const String address = '/address';
  static const String orders = "/orders";
  static const String orderSuccess = '/order-successful';
  static const String payment = '/payment';
  static const String checkout = '/checkout';
  static const String orderTracking = '/track-order';
  static const String basicCampaign = '/basic-campaign';
  static const String html = '/html';
  static const String categories = '/categories';
  static const String categoryProduct = '/category-product';
  static const String popularFoods = '/popular-foods';
  static const String itemCampaign = '/item-campaign';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String cart = '/cart';
  static const String addAddress = '/add-address';
  static const String editAddress = '/edit-address';
  static const String restaurantReview = '/restaurant-review';
  static const String allRestaurants = '/restaurants';
  static const String wallet = '/wallet';
  static const String searchRestaurantItem = '/search-Restaurant-item';
  static const String productImages = '/product-images';
  static const String referAndEarn = '/refer-and-earn';
  static const String socialPhone = '/social-phone';

  static String getInitialRoute() => '$initial';
  static String getNavigatorRoute() => '$navigatorScreen';
  static String getFastiryFoodRoute() => '$fastiryFood';
  static String getFastiryMartRoute() => '$fastiryMart';
  static String getSplashRoute(int orderID) => '$splash?id=$orderID';
  static String getOrdersRoute() => '$orders';
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getOnBoardingRoute() => '$onBoarding';
  static String getSignInRoute(String page) => '$signIn?page=$page';
  static String getSignUpRoute() => '$signUp';
  static String getVerificationRoute(
      String number, String token, String page, String pass) {
    return '$verification?page=$page&number=$number&token=$token&pass=$pass';
  }

  static String getAccessLocationRoute(String page) =>
      '$accessLocation?page=$page';
  static String getPickMapRoute(String page, bool canRoute) =>
      '$pickMap?page=$page&route=${canRoute.toString()}';
  static String getInterestRoute() => '$interest';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute(bool fromSocialLogin,
      SocialLogInBody socialLogInBody, String token, Customer user) {
    String _data;
    String _customer;
    if (fromSocialLogin) {
      _data = base64Encode(utf8.encode(jsonEncode(socialLogInBody.toJson())));
      _customer = jsonEncode(user.toJson());
    }
    return '$forgotPassword?page=${fromSocialLogin ? 'social-login' : 'forgot-password'}&data=${fromSocialLogin ? _data : 'null'}&user=$_customer&token=$token';
  }

  static String getSocialPhoneRoute(User user, String token) =>
      '$socialPhone?user=$user&token=$token';
  static String getResetPasswordRoute(
          String phone, String token, String page) =>
      '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getSearchRoute() => '$search';
  static String getRestaurantRoute(int id) => '$restaurant?id=$id';
  static String getProductDetailsRoute(int id) => '$productDetails?id=$id';
  static String getOrderDetailsRoute(int orderID) {
    return '$orderDetails?id=$orderID';
  }

  static String getProfileRoute() => '$profile';
  static String getUpdateProfileRoute() => '$updateProfile';
  static String getCouponRoute() => '$coupon';
  static String getNotificationRoute() => '$notification';
  static String getMapRoute(AddressModel addressModel, String page) {
    List<int> _encoded = utf8.encode(jsonEncode(addressModel.toJson()));
    String _data = base64Encode(_encoded);
    return '$map?address=$_data&page=$page';
  }

  static String getAddressRoute(String page) => '$address?page=$page';
  static String getOrderSuccessRoute(
          String orderID, String status, double amount) =>
      '$orderSuccess?id=$orderID&status=$status&amount=$amount';
  static String getPaymentRoute(String id, int user, double amount) =>
      '$payment?id=$id&user=$user&amount=$amount';
  static String getCheckoutRoute(String page) => '$checkout?page=$page';
  static String getOrderTrackingRoute(int id) => '$orderTracking?id=$id';
  static String getBasicCampaignRoute(BasicCampaignModel basicCampaignModel) {
    String _data =
        base64Encode(utf8.encode(jsonEncode(basicCampaignModel.toJson())));
    return '$basicCampaign?data=$_data';
  }

  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getCategoryRoute(bool fromMartScreen) =>
      '$categories?page=${fromMartScreen ? 'mart' : 'other'}';
  static String getCategoryProductRoute(int id, String name) {
    List<int> _encoded = utf8.encode(name);
    String _data = base64Encode(_encoded);
    return '$categoryProduct?id=$id&name=$_data';
  }

  static String getPopularFoodRoute(bool isPopular) =>
      '$popularFoods?page=${isPopular ? 'popular' : 'reviewed'}';
  static String getItemCampaignRoute() => '$itemCampaign';
  static String getSupportRoute() => '$support';
  static String getReviewRoute() => '$rateReview';
  static String getUpdateRoute(bool isUpdate) =>
      '$update?update=${isUpdate.toString()}';
  static String getCartRoute() => '$cart';
  static String getAddAddressRoute(bool fromCheckout) =>
      '$addAddress?page=${fromCheckout ? 'checkout' : 'address'}';
  static String getEditAddressRoute(AddressModel address) {
    String _data = base64Url.encode(utf8.encode(jsonEncode(address.toJson())));
    return '$editAddress?data=$_data';
  }

  static String getAllProductsRoute() {
    return '$allProducts';
  }

  static String getRestaurantReviewRoute(
          int restaurantID, String restaurantName) =>
      '$restaurantReview?id=$restaurantID&restaurantName=$restaurantName';
  static String getAllRestaurantRoute(String page) =>
      '$allRestaurants?page=$page';
  static String getWalletRoute(bool fromWallet) =>
      '$wallet?page=${fromWallet ? 'wallet' : 'loyalty_points'}';
  static String getSearchRestaurantProductRoute(int productID) =>
      '$searchRestaurantItem?id=$productID';
  static String getItemImagesRoute(Product product) {
    String _data = base64Url.encode(utf8.encode(jsonEncode(product.toJson())));
    return '$productImages?item=$_data';
  }

  static String getReferAndEarnRoute() => '$referAndEarn';

  static List<GetPage> routes = [
    GetPage(
        name: orders,
        page: () => InternetConnectionWrapper(
              screen: OrderScreen(),
            )),
    GetPage(name: initial, page: () => DashboardScreen(pageIndex: 0)),
    GetPage(
        name: navigatorScreen,
        page: () => InternetConnectionWrapper(screen: NavigatorScreen())),
    GetPage(
        name: fastiryFood,
        page: () => InternetConnectionWrapper(screen: FoodScreen())),
    GetPage(
        name: fastiryMart,
        page: () => InternetConnectionWrapper(screen: MartScreen())),
    GetPage(
        name: socialPhone,
        page: () {
          User user = Get.arguments;
          return InternetConnectionWrapper(
            screen: SocialPhoneScreen(
              user: user,
              token: Get.parameters['token'],
            ),
          );
        }),
    GetPage(
        name: splash,
        page: () => InternetConnectionWrapper(
              screen: SplashScreen(
                  orderID: Get.parameters['id'] == 'null'
                      ? null
                      : Get.parameters['id']),
            )),
    GetPage(
        name: language,
        page: () => InternetConnectionWrapper(
            screen: ChooseLanguageScreen(
                fromMenu: Get.parameters['page'] == 'menu'))),
    GetPage(
        name: onBoarding,
        page: () => InternetConnectionWrapper(screen: OnBoardingScreen())),
    GetPage(
        name: signIn,
        page: () => InternetConnectionWrapper(
              screen: SignInScreen(
                exitFromApp: Get.parameters['page'] == signUp ||
                    Get.parameters['page'] == splash ||
                    Get.parameters['page'] == onBoarding,
              ),
            )),
    GetPage(
        name: signUp,
        page: () => InternetConnectionWrapper(screen: SignUpScreen())),
    GetPage(
        name: verification,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['pass'].replaceAll(' ', '+'));
          String _data = utf8.decode(_decode);
          return InternetConnectionWrapper(
            screen: VerificationScreen(
              number: Get.parameters['number'],
              fromSignUp: Get.parameters['page'] == signUp,
              token: Get.parameters['token'],
              password: _data,
            ),
          );
        }),
    GetPage(
        name: accessLocation,
        page: () => InternetConnectionWrapper(
              screen: AccessLocationScreen(
                fromSignUp: Get.parameters['page'] == signUp,
                fromHome: Get.parameters['page'] == 'home',
                route: null,
              ),
            )),
    GetPage(
        name: pickMap,
        page: () {
          PickMapScreen _pickMapScreen = Get.arguments;
          bool _fromAddress = Get.parameters['page'] == 'add-address';
          return (_fromAddress && _pickMapScreen == null)
              ? NotFound()
              : _pickMapScreen != null
                  ? _pickMapScreen
                  : InternetConnectionWrapper(
                      screen: PickMapScreen(
                        fromSignUp: Get.parameters['page'] == signUp,
                        fromAddAddress: _fromAddress,
                        route: Get.parameters['page'],
                        canRoute: Get.parameters['route'] == 'true',
                      ),
                    );
        }),
    GetPage(
        name: interest,
        page: () => InternetConnectionWrapper(screen: InterestScreen())),
    GetPage(
        name: main,
        page: () => DashboardScreen(
              pageIndex: Get.parameters['page'] == 'home'
                  ? 0
                  : Get.parameters['page'] == 'favourite'
                      ? 1
                      : Get.parameters['page'] == 'cart'
                          ? 2
                          : Get.parameters['page'] == 'order'
                              ? 3
                              : Get.parameters['page'] == 'menu'
                                  ? 4
                                  : 0,
            )),
    GetPage(
        name: forgotPassword,
        page: () {
          SocialLogInBody _data;
          Customer _customer;
          if (Get.parameters['page'] == 'social-login') {
            List<int> _decode =
                base64Decode(Get.parameters['data'].replaceAll(' ', '+'));

            _data = SocialLogInBody.fromJson(jsonDecode(utf8.decode(_decode)));
            _customer = Customer.fromJson(jsonDecode(Get.parameters['user']));
          }
          return InternetConnectionWrapper(
            screen: ForgetPassScreen(
              fromSocialLogin: Get.parameters['page'] == 'social-login',
              socialLogInBody: _data,
              token: Get.parameters['token'],
              customer: _customer,
            ),
          );
        }),
    GetPage(
        name: resetPassword,
        page: () => InternetConnectionWrapper(
              screen: NewPassScreen(
                resetToken: Get.parameters['token'],
                number: Get.parameters['phone'],
                fromPasswordChange: Get.parameters['page'] == 'password-change',
              ),
            )),
    GetPage(
        name: search,
        page: () => InternetConnectionWrapper(screen: SearchScreen())),
    GetPage(
        name: restaurant,
        page: () {
          return Get.arguments != null
              ? Get.arguments
              : InternetConnectionWrapper(
                  screen: RestaurantScreen(
                      restaurant:
                          Restaurant(id: int.parse(Get.parameters['id']))),
                );
        }),
    GetPage(
        name: productDetails,
        page: () {
          return Get.arguments != null
              ? Get.arguments
              : InternetConnectionWrapper(
                  screen: ProductDetailsScreen(
                      product: Product(id: int.parse(Get.parameters['id']))),
                );
        }),
    GetPage(
        name: orderDetails,
        page: () {
          return Get.arguments != null
              ? Get.arguments
              : InternetConnectionWrapper(
                  screen: OrderDetailsScreen(
                      orderId: int.parse(Get.parameters['id'] ?? '0'),
                      orderModel: null),
                );
        }),
    GetPage(
        name: profile,
        page: () => InternetConnectionWrapper(screen: ProfileScreen())),
    GetPage(
        name: updateProfile,
        page: () => InternetConnectionWrapper(screen: UpdateProfileScreen())),
    GetPage(
        name: coupon,
        page: () => InternetConnectionWrapper(screen: CouponScreen())),
    GetPage(
        name: notification,
        page: () => InternetConnectionWrapper(screen: NotificationScreen())),
    GetPage(
        name: map,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['address'].replaceAll(' ', '+'));
          AddressModel _data =
              AddressModel.fromJson(jsonDecode(utf8.decode(_decode)));
          return InternetConnectionWrapper(
            screen: MapScreen(
                fromRestaurant: Get.parameters['page'] == 'restaurant',
                address: _data),
          );
        }),
    GetPage(
        name: address,
        page: () {
          return InternetConnectionWrapper(
            screen: AddressScreen(
              fromCheckout: Get.parameters['page'] == "checkout",
            ),
          );
        }),
    GetPage(
        name: orderSuccess,
        page: () => InternetConnectionWrapper(
              screen: OrderSuccessfulScreen(
                orderID: Get.parameters['id'],
                status: Get.parameters['status'].contains('success') ? 1 : 0,
                totalAmount: null,
              ),
            )),
    GetPage(
        name: payment,
        page: () => InternetConnectionWrapper(
              screen: PaymentScreen(
                  orderModel: OrderModel(
                id: int.parse(Get.parameters['id']),
                userId: int.parse(Get.parameters['user']),
                orderAmount: double.parse(Get.parameters['amount']),
              )),
            )),
    GetPage(
        name: checkout,
        page: () {
          CheckoutScreen _checkoutScreen = Get.arguments;
          bool _fromCart = Get.parameters['page'] == 'cart';
          return _checkoutScreen != null
              ? _checkoutScreen
              : !_fromCart
                  ? NotFound()
                  : InternetConnectionWrapper(
                      screen: CheckoutScreen(
                        cartList: null,
                        fromCart: Get.parameters['page'] == 'cart',
                      ),
                    );
        }),
    GetPage(
        name: orderTracking,
        page: () => InternetConnectionWrapper(
            screen: OrderTrackingScreen(orderID: Get.parameters['id']))),
    GetPage(
        name: basicCampaign,
        page: () {
          BasicCampaignModel _data = BasicCampaignModel.fromJson(jsonDecode(
              utf8.decode(
                  base64Decode(Get.parameters['data'].replaceAll(' ', '+')))));
          return InternetConnectionWrapper(
              screen: CampaignScreen(campaign: _data));
        }),
    GetPage(
        name: html,
        page: () => HtmlViewerScreen(
              htmlType: Get.parameters['page'] == 'terms-and-condition'
                  ? HtmlType.TERMS_AND_CONDITION
                  : Get.parameters['page'] == 'privacy-policy'
                      ? HtmlType.PRIVACY_POLICY
                      : HtmlType.ABOUT_US,
            )),
    GetPage(
        name: categories,
        page: () => InternetConnectionWrapper(
                screen: CategoryScreen(
              fromMartScreen: Get.parameters['page'] == 'mart',
            ))),
    GetPage(
        name: categoryProduct,
        page: () {
          List<int> _decode =
              base64Decode(Get.parameters['name'].replaceAll(' ', '+'));
          String _data = utf8.decode(_decode);
          return InternetConnectionWrapper(
            screen: CategoryProductScreen(
                categoryID: Get.parameters['id'], categoryName: _data),
          );
        }),
    GetPage(
        name: popularFoods,
        page: () => InternetConnectionWrapper(
            screen: PopularFoodScreen(
                isPopular: Get.parameters['page'] == 'popular'))),
    GetPage(
        name: itemCampaign,
        page: () => InternetConnectionWrapper(screen: ItemCampaignScreen())),
    GetPage(
        name: support,
        page: () => InternetConnectionWrapper(screen: SupportScreen())),
    GetPage(
        name: update,
        page: () => InternetConnectionWrapper(
            screen:
                UpdateScreen(isUpdate: Get.parameters['update'] == 'true'))),
    GetPage(
        name: cart,
        page: () =>
            InternetConnectionWrapper(screen: CartScreen(fromNav: false))),
    GetPage(
        name: addAddress,
        page: () => InternetConnectionWrapper(
              screen: AddAddressScreen(
                  fromCheckout: Get.parameters['page'] == 'checkout'),
            )),
    GetPage(
        name: editAddress,
        page: () => InternetConnectionWrapper(
              screen: AddAddressScreen(
                fromCheckout: false,
                address: AddressModel.fromJson(jsonDecode(utf8.decode(base64Url
                    .decode(Get.parameters['data'].replaceAll(' ', '+'))))),
              ),
            )),
    GetPage(
        name: allProducts,
        page: () {
          return AllProductsScreen();
        }),
    GetPage(
        name: rateReview,
        page: () => Get.arguments != null ? Get.arguments : NotFound()),
    GetPage(
        name: restaurantReview,
        page: () => InternetConnectionWrapper(
              screen: ReviewScreen(
                restaurantID: Get.parameters['id'],
                restaurantName: Get.parameters['restaurantName'],
              ),
            )),
    GetPage(
        name: allRestaurants,
        page: () => InternetConnectionWrapper(
              screen: AllRestaurantScreen(
                  isPopular: Get.parameters['page'] == 'popular'),
            )),
    GetPage(
        name: wallet,
        page: () => InternetConnectionWrapper(
            screen:
                WalletScreen(fromWallet: Get.parameters['page'] == 'wallet'))),
    GetPage(
        name: searchRestaurantItem,
        page: () => InternetConnectionWrapper(
            screen:
                RestaurantProductSearchScreen(storeID: Get.parameters['id']))),
    GetPage(
        name: productImages,
        page: () => InternetConnectionWrapper(
              screen: ImageViewerScreen(
                product: Product.fromJson(jsonDecode(utf8.decode(base64Url
                    .decode(Get.parameters['item'].replaceAll(' ', '+'))))),
              ),
            )),
    GetPage(
        name: referAndEarn,
        page: () => InternetConnectionWrapper(screen: ReferAndEarnScreen())),
  ];

  // static getRoute(Widget navigateTo) {
  //   int _minimumVersion = 0;
  //   if (GetPlatform.isAndroid) {
  //     _minimumVersion =
  //         Get.find<SplashController>().configModel.appMinimumVersionAndroid ??
  //             1;
  //   } else if (GetPlatform.isIOS) {
  //     _minimumVersion =
  //         Get.find<SplashController>().configModel.appMinimumVersionIos ?? 1;
  //   }

  //   return AppConstants.APP_VERSION < _minimumVersion
  //       ? UpdateScreen(isUpdate: true)
  //       : Get.find<SplashController>().configModel.maintenanceMode ?? false
  //           ? UpdateScreen(isUpdate: false)
  //           : Get.find<LocationController>().getUserAddress() != null
  //               ? navigateTo
  //               : AccessLocationScreen(
  //                   fromSignUp: false,
  //                   fromHome: false,
  //                   route: Get.currentRoute);
  // }
}

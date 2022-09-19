import 'package:efood_multivendor/controller/restaurant_controller.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/repository/category_repo.dart';
import 'package:efood_multivendor/data/repository/restaurant_repo.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controller/location_controller.dart';
import '../../../controller/order_controller.dart';
import '../../../data/model/response/category_model.dart';

class RestuarantViewModel extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  final RestaurantRepo restaurantRepo;

  RestuarantViewModel(
      {@required this.categoryRepo, @required this.restaurantRepo});

  bool _isAvailable;
  RxBool _isLoading = true.obs;
  int _categoryIndex = 0;
  List<CategoryModel> _restaurantCategories;
  List<CategoryModel> _restaurantSubCategories;
  List<Product> _restaurantAllProducts;
  List<Product> _categoryProducts;

  int get categoryIndex => _categoryIndex;
  bool get isAvailable => _isAvailable;
  RxBool get isLoading => _isLoading;
  List<CategoryModel> get restaurantCategories => _restaurantCategories;
  List<CategoryModel> get restaurantSubCategories => _restaurantSubCategories;
  List<Product> get restaurantAllProducts => _restaurantAllProducts;
  List<Product> get categoryProducts => _categoryProducts;

  void initRestaurantData(Restaurant restaurant) async {
    if (_isLoading.isFalse) {
      _isLoading.toggle();
    }
    print("loading is: ${_isLoading.value}");
    _categoryIndex = 0;
    _restaurantCategories.clear();
    final restaurantDetails =
        await getRestaurantDetails(restaurant.id.toString());
    setRestaurantDetails(restaurantDetails);
    setResturantCategories(restaurantDetails);
    getRestaurantProducts(restaurantDetails);

    update();

    print("loading is: ${_isLoading.value}");
    print("restaurant screen called init");
  }

  Future<Restaurant> getRestaurantDetails(String restaurantId) async {
    Restaurant restaurant;
    try {
      final response = await restaurantRepo.getRestaurantDetails(restaurantId);

      if (response.statusCode == 200) {
        restaurant = Restaurant.fromJson(response.body);
      }
    } catch (err) {}

    return restaurant;
  }

  void setRestaurantDetails(Restaurant restaurant) async {
    Get.find<OrderController>().initializeTimeSlot(restaurant);
    Get.find<OrderController>().getDistanceInMeter(
      LatLng(
        double.parse(Get.find<LocationController>().getUserAddress().latitude),
        double.parse(Get.find<LocationController>().getUserAddress().longitude),
      ),
      LatLng(double.parse(restaurant.latitude),
          double.parse(restaurant.longitude)),
    );

    _isAvailable = Get.find<RestaurantController>()
        .isRestaurantOpenNow(restaurant.active, restaurant.schedules);
    // set restaurant avalability

    update();
  }

  void setResturantCategories(Restaurant restaurant) {
    _restaurantCategories = [];
    if (restaurant.categories.isNotEmpty) {
      restaurant.categories.forEach((category) async {
        final response =
            await categoryRepo.getSubCategoryList(category.id.toString());

        if (response.statusCode == 200) {
          response.body.forEach((category) =>
              _restaurantCategories.add(CategoryModel.fromJson(category)));
          // _restaurantSubCategories.addAll(CategoryModel.fromJson(response.body));
        }
      });
    }
    _restaurantCategories.insert(
        0,
        CategoryModel(
          id: -1,
          parentId: -1,
          name: "all".tr,
        ));

    update();
    // _restaurantCategories = [];

    // _restaurantCategories.addAll(restaurant.categories);
  }

  Future<void> getRestaurantProducts(Restaurant restaurant) async {
    try {
      Response response = await restaurantRepo.getRestaurantProductList(
        restaurant.id,
        1,
        0,
        'all',
      );
      if (response.statusCode == 200) {
        _restaurantAllProducts = [];
        _categoryProducts = [];
        _restaurantAllProducts
            .addAll(ProductModel.fromJson(response.body).products);

        _categoryProducts.addAll(ProductModel.fromJson(response.body).products);

        // _isLoading = false;

      }
      if (_isLoading.isTrue) {
        _isLoading.toggle();
      }
      update();
    } catch (err) {
      showCustomSnackBar(err);
    }
  }

  void setCategoryIndex(int index, int categoryId) {
    _categoryIndex = index;

    if (categoryId == -1) {
      _categoryProducts = List.from(_restaurantAllProducts);
    } else {
      _categoryProducts = [];
      _categoryProducts = _restaurantAllProducts
          .where((product) => product.categoryId == categoryId)
          .toList();
    }

    update();
  }
}

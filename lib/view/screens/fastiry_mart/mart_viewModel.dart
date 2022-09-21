import '/data/api/api_checker.dart';
import '/data/model/response/category_model.dart';
import '/view/base/custom_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controller/location_controller.dart';
import '../../../controller/order_controller.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../data/model/response/product_model.dart';
import '../../../data/model/response/restaurant_model.dart';
import '../../../data/repository/restaurant_repo.dart';

class MartViewModel extends GetxController {
  final RestaurantRepo restaurantRepo;
  bool _isLoading = true;

  Restaurant _fastiryMart;

  List<Product> _martProducts = [];

  List<CategoryModel> _martCategories = [];

  MartViewModel({@required this.restaurantRepo});

  bool get isLoading => _isLoading;
  Restaurant get fastiryMart => _fastiryMart;
  List<Product> get martProducts => _martProducts;
  List<CategoryModel> get martCategories => _martCategories;

  final restaurantController = Get.find<RestaurantController>();
  void martScreenIntial() {
    _isLoading = true;
    getFasteryMartDetails();
    getRestaurantProducts();
    // _isLoading = false;

    // update();
  }

  Future<void> getFasteryMartDetails() async {
    try {
      final response = await restaurantRepo.getRestaurantDetails('12');

      if (response.statusCode == 200) {
        _fastiryMart = Restaurant.fromJson(response.body);
        if (_fastiryMart.categories.isNotEmpty) {
          _martCategories = _fastiryMart.categories;
        }
        Get.find<OrderController>().initializeTimeSlot(_fastiryMart);
        Get.find<OrderController>().getDistanceInMeter(
          LatLng(
            double.parse(
                Get.find<LocationController>().getUserAddress().latitude),
            double.parse(
                Get.find<LocationController>().getUserAddress().longitude),
          ),
          LatLng(double.parse(_fastiryMart.latitude),
              double.parse(_fastiryMart.longitude)),
        );
      } else {
        ApiChecker.checkApi(response);
      }

      update();
    } catch (err) {
      showCustomSnackBar(err);
    }
  }

  Future<void> getRestaurantProducts() async {
    _martProducts.clear();
    Response response = await restaurantRepo.getRestaurantProductList(
      12,
      1,
      0,
      'all',
    );
    if (response.statusCode == 200) {
      _martProducts.addAll(ProductModel.fromJson(response.body).products);
    }
    _isLoading = false;
    update();
  }
}

import 'package:efood_multivendor/data/api/api_checker.dart';
import 'package:efood_multivendor/data/errors/exeptions.dart';
import 'package:efood_multivendor/data/model/response/product_model.dart';
import 'package:efood_multivendor/data/model/response/restaurant_model.dart';
import 'package:efood_multivendor/data/repository/product_repo.dart';
import 'package:efood_multivendor/data/repository/wishlist_repo.dart';
import 'package:efood_multivendor/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListController extends GetxController implements GetxService {
  final WishListRepo wishListRepo;
  final ProductRepo productRepo;
  WishListController({@required this.wishListRepo, @required this.productRepo});

  List<Product> _wishProductList;
  List<Restaurant> _wishRestList;
  List<int> _wishProductIdList = [];
  List<int> _wishRestIdList = [];

  List<Product> get wishProductList => _wishProductList;
  List<Restaurant> get wishRestList => _wishRestList;
  List<int> get wishProductIdList => _wishProductIdList;
  List<int> get wishRestIdList => _wishRestIdList;

  void addToWishList(
      Product product, Restaurant restaurant, bool isRestaurant) async {
    Response response = await wishListRepo.addWishList(
        isRestaurant ? restaurant.id : product.id, isRestaurant);
    if (response.statusCode == 200) {
      if (isRestaurant) {
        _wishRestIdList.add(restaurant.id);
        _wishRestList.add(restaurant);
      } else {
        _wishProductList.add(product);
        _wishProductIdList.add(product.id);
      }
      showCustomSnackBar("succsesfully_added_wishlist".tr, isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeFromWishList(int id, bool isRestaurant) async {
    Response response = await wishListRepo.removeWishList(id, isRestaurant);
    if (response.statusCode == 200) {
      int _idIndex = -1;
      if (isRestaurant) {
        _idIndex = _wishRestIdList.indexOf(id);
        _wishRestIdList.removeAt(_idIndex);
        _wishRestList.removeAt(_idIndex);
      } else {
        _idIndex = _wishProductIdList.indexOf(id);
        _wishProductIdList.removeAt(_idIndex);
        _wishProductList.removeAt(_idIndex);
      }
      showCustomSnackBar("succsesfully_removed_wishlist".tr, isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWishList() async {
    _wishProductList = [];
    _wishRestList = [];
    _wishRestIdList = [];
    try {
      final response = await wishListRepo.getWishList();

      _wishProductList.addAll(response.food);
      response.food.forEach((food) async {
        _wishProductList.add(food);
        _wishProductIdList.add(food.id);
      });
      response.restaurant.forEach((restaurant) async {
        _wishRestList.add(restaurant);
        _wishRestIdList.add(restaurant.id);
      });
    } on ServerException catch (err) {
      showCustomSnackBar(err.message);
    }

    update();
  }

  void removeWishes() {
    _wishProductIdList = [];
    _wishRestIdList = [];
  }
}

import 'dart:async';

import '/data/api/api_checker.dart';
import '/data/model/response/cart_model.dart';
import '/data/model/response/product_model.dart';
import '/data/repository/cart_repo.dart';
import '/data/repository/restaurant_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/restaurant_model.dart';
import '../helper/date_converter.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  final RestaurantRepo restaurantRepo;
  CartController({@required this.cartRepo, @required this.restaurantRepo});

  List<CartModel> _cartList = [];
  bool _isLoading = true;
  Restaurant _cartRestaurant;
  double _cartSubTotal = 0;
  double _subTotal = 0;
  List<List<AddOns>> _addOnsList = [];
  List<bool> _availableList = [];
  double _itemPrice = 0;
  double _addOns = 0;
  double get subTotal => _subTotal;

  double get cartSubTotal => _cartSubTotal;

  double get itemPrice => _itemPrice;
  double get addOns => _addOns;
  List<List<AddOns>> get addOnsList => _addOnsList;
  List<bool> get availableList => _availableList;

  List<CartModel> get cartList => _cartList;
  Restaurant get cartRestaurant => _cartRestaurant;
  bool get isLoading => _isLoading;
  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    update();
  }

  Future<void> initCartScreen() async {
    _subTotal = 0;
    _addOnsList = [];
    _availableList = [];
    _itemPrice = 0;
    _addOns = 0;

    final restaurant = await getCartRestaurant();
    if (_cartList.isNotEmpty) {
      _cartList.forEach((cartModel) {
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
              (_addOnList[index].price * cartModel.addOnIds[index].quantity);
        }
        _itemPrice = _itemPrice + (cartModel.price * cartModel.quantity);
      });

      if (restaurant != null) {
        _subTotal = _itemPrice + _addOns + restaurant.deliveryPrice;
      } else {
        _subTotal = _itemPrice + _addOns;
      }
    } else {
      _subTotal = 0;
    }

    update();
  }

  Future<Restaurant> getCartRestaurant() async {
    int restaurantId;
    _isLoading = true;
    if (_cartList.isNotEmpty) {
      restaurantId = _cartList.first.product.restaurantId;
      final response =
          await restaurantRepo.getRestaurantDetails(restaurantId.toString());

      if (response.statusCode == 200) {
        _cartRestaurant = Restaurant.fromJson(response.body);
      } else {
        ApiChecker.checkApi(response);
      }
    }
    _isLoading = false;
    update();

    return _cartRestaurant;
  }

  void addToCart(CartModel cartModel, int index) {
    bool isProductExistinCart = false;
    // if (index != null && index != -1) {
    //   _cartList.replaceRange(index, index + 1, [cartModel]);
    // } else {
    for (var cartItem in _cartList) {
      if (cartModel.product.id == cartItem.product.id) {
        cartModel.quantity += cartItem.quantity;
        isProductExistinCart = true;
      }
    }

    if (isProductExistinCart) {
      _cartList
          .removeWhere((element) => element.product.id == cartModel.product.id);
    }
    _cartList.add(cartModel);
    // }
    cartRepo.addToCartList(_cartList);
    _subTotal = getCartSubTotal();
    update();
  }

  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _itemPrice += _cartList[index].price;
      _subTotal += _cartList[index].price;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _itemPrice -= _cartList[index].price;
      _subTotal -= _cartList[index].price;
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(int index) {
    if (_cartList.length == 1) {
      _subTotal = 0;
      _addOnsList = [];
      _availableList = [];
      _itemPrice = 0;
      _addOns = 0;
      clearCartList();
    } else {
      final product = _cartList[index];

      _cartList.removeAt(index);
      _itemPrice -= product.price;
      _subTotal -= product.price;
    }
    cartRepo.addToCartList(_cartList);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartList() {
    _cartList = [];
    _cartRestaurant = null;
    cartRepo.addToCartList(_cartList);
    update();
  }

  int isExistInCart(
      int productID, String variationType, bool isUpdate, int cartIndex) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == productID &&
          (_cartList[index].variation.length > 0
              ? _cartList[index].variation[0].type == variationType
              : true)) {
        if ((isUpdate && index == cartIndex)) {
          return -1;
        } else {
          return index;
        }
      }
    }
    return -1;
  }

  bool isProductExistInCart(int productId) {
    bool isExist = false;

    for (CartModel cartItem in _cartList) {
      if (cartItem.product.id == productId) {
        isExist = true;
        break;
      }
    }

    return isExist;
  }

  int getCartIndex(Product product) {
    for (int index = 0; index < _cartList.length; index++) {
      if (_cartList[index].product.id == product.id) {
        if (_cartList[index].product.variations[0].type != null) {
          if (_cartList[index].product.variations[0].type ==
              product.variations[0].type) {
            return index;
          }
        } else {
          return index;
        }
      }
    }
    return null;
  }

  bool existAnotherRestaurantProduct(int restaurantID) {
    for (CartModel cartModel in _cartList) {
      if (cartModel.product.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    cartRepo.addToCartList(_cartList);
    _subTotal = getCartSubTotal();
    update();
  }

  double getCartSubTotal() {
    _cartSubTotal = 0;
    _subTotal = 0;
    for (var cartProduct in _cartList) {
      _subTotal += (cartProduct.quantity * cartProduct.price);
    }

    update();

    return _subTotal;
  }
}

import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/data/model/response/wish_list_model/wish_list_model.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class WishListRepo {
  final ApiConsumer apiClient;
  WishListRepo({@required this.apiClient});

  Future<WishListModel> getWishList() async {
    return await apiClient.get(AppConstants.WISH_LIST_GET_URI);
  }

  Future<Response> addWishList(int id, bool isRestaurant) async {
    return await apiClient
        .post('${AppConstants.ADD_WISH_LIST_URI}', queryParams: {
      "${isRestaurant ? 'restaurant_id' : 'food_id'}": "$id",
    }, body: {});
  }

  Future<Response> removeWishList(int id, bool isRestaurant) async {
    return await apiClient
        .delete('${AppConstants.REMOVE_WISH_LIST_URI}', queryParams: {
      "${isRestaurant ? 'restaurant_id' : 'food_id'}": "$id",
    });
  }
}

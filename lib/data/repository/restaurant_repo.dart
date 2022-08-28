import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class RestaurantRepo {
  final ApiConsumer apiClient;
  RestaurantRepo({@required this.apiClient});

  Future<Response> getRestaurantList(int offset, String filterBy) async {
    return await apiClient.get('${AppConstants.RESTAURANT_URI}/$filterBy',
        queryParams: {"offset": "$offset", "limit": "10"});
  }

  Future<Response> getPopularRestaurantList(String type) async {
    return await apiClient.get('${AppConstants.POPULAR_RESTAURANT_URI}',
        queryParams: {"type": type});
  }

  Future<Response> getLatestRestaurantList(String type) async {
    return await apiClient.get('${AppConstants.LATEST_RESTAURANT_URI}',
        queryParams: {"type": type});
  }

  Future<Response> getRestaurntByID(String restaurantId) async {
    return await apiClient
        .get('${AppConstants.singleRestaurantUri}$restaurantId');
  }

  Future<Response> getRestaurantDetails(String restaurantID) async {
    return await apiClient
        .get('${AppConstants.RESTAURANT_DETAILS_URI}$restaurantID');
  }

  Future<Response> getRestaurantProductList(
      int restaurantID, int offset, int categoryID, String type) async {
    return await apiClient
        .get('${AppConstants.RESTAURANT_PRODUCT_URI}', queryParams: {
      "restaurant_id": "$restaurantID",
      "category_id": "$categoryID",
      "offset": "$offset",
      "limit": "10",
      "type": "$type"
    });
  }

  Future<Response> getRestaurantSearchProductList(
      String searchText, String storeID, int offset, String type) async {
    return await apiClient
        .get('${AppConstants.SEARCH_URI}products/search', queryParams: {
      "restaurant_id": "$storeID",
      "name": "$searchText",
      "offset": "$offset",
      "limit": "10",
      "type": "$type"
    });
  }

  Future<Response> getRestaurantReviewList(String restaurantID) async {
    return await apiClient
        .get('${AppConstants.RESTAURANT_REVIEW_URI}', queryParams: {
      "restaurant_id": "$restaurantID",
    });
  }
}

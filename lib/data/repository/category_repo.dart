import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CategoryRepo {
  final ApiConsumer apiClient;
  CategoryRepo({@required this.apiClient});

  Future<Response> getCategoryList() async {
    return await apiClient.get(AppConstants.CATEGORY_URI);
  }

  Future<Response> getSubCategoryList(String parentID) async {
    return await apiClient.get('${AppConstants.SUB_CATEGORY_URI}$parentID');
  }

  Future<Response> getCategoryProductList(
      String categoryID, int offset, String type) async {
    return await apiClient
        .get('${AppConstants.CATEGORY_PRODUCT_URI}$categoryID', queryParams: {
      "limit": "10",
      "offset": offset.toString(),
      "type": type.toString()
    });
  }

  Future<Response> getCategoryRestaurantList(
      String categoryID, int offset, String type) async {
    return await apiClient.get(
        '${AppConstants.CATEGORY_RESTAURANT_URI}$categoryID',
        queryParams: {
          "limit": "10",
          "offset": offset.toString(),
          "type": type.toString()
        });
  }

  Future<Response> getSearchData(
      String query, String categoryID, bool isRestaurant, String type) async {
    return await apiClient.get(
        '${AppConstants.SEARCH_URI}${isRestaurant ? 'restaurants' : 'products'}/search',
        queryParams: {
          "limit": "50",
          "offset": "1",
          "type": type.toString(),
          "name": query,
          "category_id": categoryID
        });
  }

  Future<Response> saveUserInterests(List<int> interests) async {
    return await apiClient
        .post(AppConstants.INTEREST_URI, body: {"interest": interests});
  }
}

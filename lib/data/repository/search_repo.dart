import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchRepo {
  final ApiConsumer apiClient;
  final SharedPreferences sharedPreferences;
  SearchRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> getSearchData(String query, bool isRestaurant) async {
    return await apiClient.get(
        '${AppConstants.SEARCH_URI}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&offset=1&limit=50',
        queryParams: {
          "name": "$query",
          "offset": "1",
          "limit": "50",
        });
  }

  Future<Response> getSuggestedFoods() async {
    return await apiClient.get(AppConstants.SUGGESTED_FOOD_URI);
  }

  Future<bool> saveSearchHistory(List<String> searchHistories) async {
    return await sharedPreferences.setStringList(
        AppConstants.SEARCH_HISTORY, searchHistories);
  }

  List<String> getSearchAddress() {
    return sharedPreferences.getStringList(AppConstants.SEARCH_HISTORY) ?? [];
  }

  Future<bool> clearSearchHistory() async {
    return sharedPreferences.setStringList(AppConstants.SEARCH_HISTORY, []);
  }
}

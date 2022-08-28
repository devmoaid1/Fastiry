import 'package:efood_multivendor/data/api/api_consumer.dart';
import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BannerRepo {
  final ApiConsumer apiClient;
  BannerRepo({@required this.apiClient});

  Future<Response> getBannerList() async {
    return await apiClient.get(AppConstants.BANNER_URI);
  }
}
